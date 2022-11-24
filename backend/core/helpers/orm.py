from dataclasses import dataclass
from typing import Generic, Optional, Type, TypeVar

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

        # Avoid cyclic imports
        from core.signals import model_created

        instance = cls(**kwargs, **(_related or {}))
        instance.save()
        model_created.send(cls, data=instance)
        return instance

    @classmethod
    @raises(PendingRollbackError)
    def get(cls, **kwargs) -> "CrudModel":
        return cls.get_query().filter(**kwargs).scalar_one()

    @classmethod
    @raises(PendingRollbackError)
    def get_or_none(cls, **kwargs) -> "Optional[CrudModel]":
        return cls.get_query().filter(**kwargs).scalar_one_or_none()

    @classmethod
    @raises(ValueError, MultipleResultsFound, IntegrityError, PendingRollbackError)
    def get_or_create(cls, *, _related=None, **kwargs) -> "CrudModel":
        try:
            partial_matches = cls.filter(**kwargs)
            if _related is not None:
                # Check relationships as well
                exact_matches = [
                    candidate
                    for candidate in partial_matches
                    if all(
                        getattr(candidate, key, None) == value
                        for key, value in _related.items()
                    )
                ]
            else:
                exact_matches = partial_matches

            if not exact_matches:
                return cls.create(_related=_related, **kwargs)
            elif len(exact_matches) == 1:
                return exact_matches[0]
            else:
                raise MultipleResultsFound(
                    "Multiple rows were found when exactly one was required"
                )
        except NoResultFound:
            return cls.create(_related=_related, **kwargs)

    @classmethod
    @raises(PendingRollbackError)
    def all(cls) -> "list[CrudModel]":
        return cls.filter()

    @classmethod
    @raises(PendingRollbackError)
    def filter(cls, **kwargs) -> "list[CrudModel]":
        return cls.get_query().filter(**kwargs).scalars().all()

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
