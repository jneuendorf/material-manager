from typing import Generic, TypeVar

from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.engine import Result
from sqlalchemy.orm import scoped_session
from sqlalchemy.sql import Select

M = TypeVar("M")


class Query(Generic[M]):
    db: SQLAlchemy
    model: M

    def __init__(self, db: SQLAlchemy, model: M):
        self.db = db
        self.model = model

    def execute(self, select: Select) -> Result:
        session: scoped_session = self.db.session
        return session.execute(select)

    def select(self) -> Select:
        return self.db.select(self.model)

    def get(self, **kwargs) -> M:
        return self._filter_by(**kwargs).scalar_one()

    def all(self):
        return self.filter()

    def filter(self, **kwargs) -> list[M]:
        return self._filter_by(**kwargs).scalars().all()

    def _filter_by(self, **kwargs) -> Result:
        return self.execute(self.select().filter_by(**kwargs))
