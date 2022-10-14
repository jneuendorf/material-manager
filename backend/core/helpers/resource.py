from collections.abc import Callable, Collection
from functools import cached_property
from typing import Generic, Type, TypeVar

from flask_apispec import MethodResource
from flask_marshmallow import Schema as BaseSchema
from flask_marshmallow.sqla import SQLAlchemySchema
from flask_restful import Resource
from flask_sqlalchemy import SQLAlchemy

from .orm import Query

M = TypeVar("M")


class ModelMeta(SQLAlchemySchema.Meta, Generic[M]):
    fields: Collection[str]
    model: M


class ModelMetaSchema(SQLAlchemySchema, Generic[M]):
    Meta: ModelMeta[M]


class ModelResource(MethodResource, Resource, Generic[M]):
    """
    Binds URLs to a model resource. Example:

    >>> @with_db(db)
    >>> class UserResource(ModelResource[User]):
    >>>     urls = ("/user/<int:user_id>",)
    >>>
    >>>     class Schema(SQLAlchemySchema):
    >>>         class Meta:
    >>>             model = User
    >>>             fields = ("id", "first_name", "last_name")
    >>>
    >>>     def get(self, user_id: int) -> User:
    >>>         instance = self.orm.get(id=user_id)
    >>>         return self.schema.dump(instance)
    """

    urls: Collection[str]
    Schema: Type[ModelMetaSchema[M]]
    db: SQLAlchemy

    @cached_property
    def schema(self) -> BaseSchema:
        return self.Schema()

    @property
    def model(self):
        return self.Schema.Meta.model

    @property
    def orm(self) -> Query[M]:
        return Query(self.db, self.model)


class ModelListResource(ModelResource, Generic[M]):
    @cached_property
    def schema(self) -> BaseSchema:
        return self.Schema(many=True)


R = TypeVar("R", bound=Type[ModelResource])


def with_db(db: SQLAlchemy) -> Callable[[R], R]:
    """Use as decorator for your resources.
    Injects the app's `SQLAlchemy` object into the `ModelResource`,
    such that DB queries can be conveniently made using `resource.orm`.
    """

    def wrapper(cls: R):
        cls.db = db
        return cls

    return wrapper
