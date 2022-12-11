from collections.abc import Collection
from dataclasses import dataclass
from typing import Any, Generic, Optional, Type, TypeVar, Union

from flask_sqlalchemy import SQLAlchemy
from flask_sqlalchemy.model import Model
from sqlalchemy.engine import Result
from sqlalchemy.exc import (
    DatabaseError,
    IntegrityError,
    MultipleResultsFound,
    NoResultFound,
    PendingRollbackError,
    SQLAlchemyError,
)
from sqlalchemy.orm import scoped_session
from sqlalchemy.sql import Select
from sqlalchemy.sql.schema import Table

from .decorators import raises


def related_equal(
    a: "Union[CrudModel, Collection[CrudModel]]",
    b: "Union[CrudModel, Collection[CrudModel]]",
) -> bool:
    """Compares model instances that have relationships to a certain model, e.g. for
    >>> ModelA.filter(id=1, _related=dict(rel=[x]))
    this function checks if
    >>> ModelA.get(id=1).x.id == x.id
    """
    if isinstance(a, CrudModel) and isinstance(b, CrudModel):
        a = [a]
        b = [b]
    return {getattr(instance, instance.pk) for instance in a} == {
        getattr(instance, instance.pk) for instance in b
    }


@dataclass
class CrudModel(Model):
    """Inspired by
    https://flask-diamond.readthedocs.io/en/stable/_modules/flask_diamond/mixins/crud/
    """

    __table__: Table
    pk = "id"
    _query: "Optional[Query]" = None
    # https://docs.sqlalchemy.org/en/14/orm/declarative_tables.html#declarative-table-configuration
    # https://www.pythonfixing.com/2022/02/fixed-what-is-use-of-tableargs-true-in.html
    # => Meta.abstract = True
    __table_args__ = {"extend_existing": True}

    # Type hint so that any arguments can be passed.
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    @classmethod
    def get_query(cls) -> "Query":
        if cls._query is None:
            db = cls.__fsa__
            cls._query = Query(db, cls)
        return cls._query

    @classmethod
    @raises(ValueError, MultipleResultsFound, IntegrityError, PendingRollbackError)
    def create(cls, *, _related=None, **kwargs):
        try:
            print(cls.get(_related=_related, **kwargs))
            raise ValueError(f"{cls.__name__}(**{kwargs}) already exists")
        # This could be left out but makes it clear what errors can occur.
        except (IntegrityError, MultipleResultsFound):
            raise
        except NoResultFound:
            pass

        return cls._create(_related=_related, **kwargs)

    @classmethod
    def _create(cls, *, _related=None, **kwargs):
        # Avoid cyclic imports
        from core.signals import model_created

        instance = cls(**kwargs, **(_related or {}))
        instance.save()
        model_created.send(cls, data=instance)
        return instance

    @classmethod
    @raises(NoResultFound, MultipleResultsFound, PendingRollbackError)
    def get(cls, *, _related=None, **kwargs) -> "CrudModel":
        if _related is None:
            return cls.get_query().filter(**kwargs).scalar_one()

        matches = cls.filter(_related=_related, **kwargs)
        if not matches:
            raise NoResultFound("No row was found when one was required")
        elif len(matches) == 1:
            return matches[0]
        else:
            print(cls, kwargs, _related)
            raise MultipleResultsFound(
                "Multiple rows were found when exactly one was required"
            )

    @classmethod
    @raises(PendingRollbackError)
    def get_or_none(cls, *, _related=None, **kwargs) -> "Optional[CrudModel]":
        try:
            return cls.get(_related=_related, **kwargs)
        except NoResultFound:
            return None

    @classmethod
    @raises(MultipleResultsFound, IntegrityError, PendingRollbackError)
    def get_or_create(cls, *, _related=None, **kwargs) -> "CrudModel":
        try:
            return cls.get(_related=_related, **kwargs)
        except NoResultFound:
            return cls._create(_related=_related, **kwargs)

    @classmethod
    @raises(PendingRollbackError)
    def all(cls) -> "list[CrudModel]":
        return cls.filter()

    @classmethod
    @raises(PendingRollbackError)
    def filter(cls, *, _related=None, **kwargs) -> "list[CrudModel]":
        partial_matches = cls.get_query().filter(**kwargs).scalars().all()
        if _related is None:
            return partial_matches

        # Check relationships
        exact_matches: list[CrudModel] = [
            candidate
            for candidate in partial_matches
            if all(
                related_equal(getattr(candidate, key), value)
                for key, value in _related.items()
            )
        ]
        return exact_matches

    @classmethod
    @raises(PendingRollbackError)
    def first_n(cls, n: int, **kwargs) -> "list[CrudModel]":
        return cls.get_query().filter(_limit=n, **kwargs).scalars().all()

    @classmethod
    def _scalars_and_related(
        cls,
        kwargs: dict[str, Any],
    ) -> "tuple[dict[str, Any], dict[str, Union[CrudModel, list[CrudModel]]]]":
        scalars: dict[str, Any] = {}
        relations: dict[str, Union[CrudModel, list[CrudModel]]] = {}
        for key, value in kwargs.items():
            # Non-relational columns usually initialize to something empty like `None`
            # while relationships usually initialize to an `InstrumentedList`
            if isinstance(value, (list, CrudModel)):
                if isinstance(value, list):
                    assert all(
                        isinstance(elem, CrudModel) for elem in value
                    ), "List query keyword argument contains non-models"
                relations[key] = value
            else:
                scalars[key] = value
        return scalars, relations

    @property
    def attrs(self) -> dict[str, Any]:
        attrs = dict(self.__dict__)
        attrs.pop("_sa_instance_state")
        return attrs

    def update(self, **kwargs):
        for field, value in kwargs.items():
            setattr(self, field, value)
        self.save()
        # TODO: send update signal

    def save(self) -> None:
        db = self.__fsa__
        db.session.add(self)
        db.session.commit()

    def ensure_saved(self, exclude: Collection[str] = ("id",)) -> "CrudModel":
        """Makes sure this or an equal instance exists in the database"""
        try:
            self.save()
            return self
        except (DatabaseError, SQLAlchemyError) as e:
            attrs = {
                key: value for key, value in self.attrs.items() if key not in exclude
            }
            cls = type(self)
            # We need to rollback because the save above has failed
            # and the transaction is still pending.
            cls.get_query().rollback()
            scalars, related = cls._scalars_and_related(attrs)
            if related:
                raise TypeError("Handling relationships is not supported")

            instance = cls.get_or_none(_related=related, **scalars)
            if instance is None:
                raise ValueError(
                    f"Both save and get failed for {({**related, **scalars})}"
                ) from e
            return instance

    def delete(self) -> None:
        # Avoid cyclic imports
        from core.signals import model_deleted

        db = self.__fsa__
        db.session.delete(self)
        db.session.commit()
        model_deleted.send(type(self), data=self)

    def __repr__(self):
        return "<{} ({})>".format(self.__class__.__name__, getattr(self, self.pk))


M = TypeVar("M", bound=CrudModel)


class Query(Generic[M]):
    db: SQLAlchemy
    model: Type[M]

    def __init__(self, db: SQLAlchemy, model: Type[M]):
        self.db = db
        self.model = model

    def select(self) -> Select:
        return self.db.select(self.model)

    def filter(self, _limit: Optional[int] = None, **kwargs) -> Result:
        return self.execute(self.select().filter_by(**kwargs).limit(_limit))

    def execute(self, statement: Select) -> Result:
        session: scoped_session = self.db.session
        try:
            return session.execute(statement)
        except PendingRollbackError:
            self.rollback()
            raise

    def rollback(self):
        session: scoped_session = self.db.session
        session.rollback()
