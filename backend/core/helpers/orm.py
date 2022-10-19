from dataclasses import dataclass
from typing import Generic, Optional, Type, TypeVar

from flask_sqlalchemy import SQLAlchemy
from flask_sqlalchemy.model import Model
from sqlalchemy.engine import Result
from sqlalchemy.exc import MultipleResultsFound, NoResultFound
from sqlalchemy.orm import scoped_session
from sqlalchemy.sql import Select


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

    @classmethod
    def get_query(cls) -> "Query":
        if cls._query is None:
            db = cls.__fsa__
            cls._query = Query(db, cls)
        return cls._query

    @classmethod
    def create(cls, *, _related=None, **kwargs):

        already_exists = False
        try:
            cls.get(**kwargs)
            already_exists = True
        except MultipleResultsFound:
            already_exists = True
        except NoResultFound:
            pass

        if already_exists:
            raise ValueError(
                f"Cannot create {cls.__name__} instance. "
                f"One already exists with {str(kwargs)}"
            )

        # Avoid cyclic imports
        from core.signals import model_created

        instance = cls(**kwargs, **(_related or {}))
        instance.save()
        model_created.send(cls, instance=instance)
        return instance

    @classmethod
    def get(cls, **kwargs):
        return cls.get_query().get(**kwargs)

    @classmethod
    def get_or_none(cls, **kwargs):
        return cls.get_query().get_or_none(**kwargs)

    @classmethod
    def get_or_create(cls, *, _related=None, **kwargs):
        try:
            return cls.get(**kwargs)
        except NoResultFound:
            return cls.create(_related=_related, **kwargs)

    @classmethod
    def all(cls):
        return cls.filter()

    @classmethod
    def filter(cls, **kwargs):
        return cls.get_query().filter(**kwargs)

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
        db = self.__fsa__
        db.session.delete(self)
        db.session.commit()
        # TODO: send delete signal

    def __repr__(self):
        return "<{} ({})>".format(self.__class__.__name__, getattr(self, self.pk))


M = TypeVar("M", bound=CrudModel)


class Query(Generic[M]):
    db: SQLAlchemy
    model: Type[M]

    def __init__(self, db: SQLAlchemy, model: Type[M]):
        self.db = db
        self.model = model

    # def execute(self, select: Select) -> Result:
    #     session: scoped_session = self.db.session
    #     return session.execute(select)

    def select(self) -> Select:
        return self.db.select(self.model)

    def get(self, **kwargs) -> M:
        return self._filter_by(**kwargs).scalar_one()

    def get_or_none(self, **kwargs) -> M:
        return self._filter_by(**kwargs).scalar_one_or_none()

    def filter(self, **kwargs) -> list[M]:
        return self._filter_by(**kwargs).scalars().all()

    def _filter_by(self, **kwargs) -> Result:
        session: scoped_session = self.db.session
        return session.execute(self.select().filter_by(**kwargs))
