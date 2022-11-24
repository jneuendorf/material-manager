from collections.abc import Collection
from dataclasses import dataclass
from typing import Generic, Optional, Type, TypeVar, Union

from flask_sqlalchemy import SQLAlchemy
from flask_sqlalchemy.model import Model
from sqlalchemy.engine import Result
from sqlalchemy.exc import (
    IntegrityError,
    MultipleResultsFound,
    NoResultFound,
    PendingRollbackError,
)
from sqlalchemy.orm import scoped_session
from sqlalchemy.sql import Select

from .decorators import raises


def related_equal(
    a: "Union[CrudModel, Collection[CrudModel]]",
    b: "Union[CrudModel, Collection[CrudModel]]",
) -> bool:
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
            cls.get(**kwargs)
            raise ValueError(f"{cls.__name__}(**{kwargs}) already exists")
        except MultipleResultsFound:
            raise
        except NoResultFound:
            pass
        # This could be left out but makes it clear what errors can occur.
        except IntegrityError:
            raise

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
    def get_or_none(cls, **kwargs) -> "Optional[CrudModel]":
        return cls.get_query().filter(**kwargs).scalar_one_or_none()

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

    def update(self, **kwargs):
        for field, value in kwargs.items():
            setattr(self, field, value)
        if self.save():
            # TODO: send update signal
            ...

    def save(self) -> None:
        db = self.__fsa__
        db.session.add(self)
        db.session.commit()

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
        return self._execute(self.select().filter_by(**kwargs).limit(_limit))

    def _execute(self, statement: Select) -> Result:
        session: scoped_session = self.db.session
        try:
            return session.execute(statement)
        except PendingRollbackError:
            session.rollback()
            raise
