from collections.abc import Collection
from functools import cached_property
from typing import Generic, List, Type, TypeVar

from flask_apispec import MethodResource
from flask_marshmallow.sqla import SQLAlchemySchema
from flask_restful import Resource

from .orm import CrudModel

M = TypeVar("M", bound=CrudModel)


class BaseResource(MethodResource, Resource):
    url: str


class ModelMeta(SQLAlchemySchema.Meta, Generic[M]):
    fields: Collection[str]
    model: Type[M]


class ModelMetaSchema(SQLAlchemySchema, Generic[M]):
    Meta: Type[ModelMeta[M]]


class ModelResource(BaseResource, Generic[M]):
    """Specifies how to serialize a model instance for each request type."""

    url: str
    Meta: Type[ModelMeta[M]]

    @cached_property
    def schema(self) -> ModelMetaSchema:
        class Schema(ModelMetaSchema):
            Meta = self.Meta

        return Schema()

    def serialize(self, instance: M):
        serialized: dict = self.schema.dump(instance)
        return serialized


class ModelListResource(ModelResource, Generic[M]):
    @cached_property
    def schema(self) -> ModelMetaSchema:
        class Schema(ModelMetaSchema):
            Meta = self.Meta

        return Schema(many=True)

    def serialize(self, instance: M):
        serialized: List[dict] = self.schema.dump(instance)
        return serialized


# R = TypeVar("R", bound=Type[ModelResource])


# def with_db(db: SQLAlchemy) -> Callable[[R], R]:
#     """Use as decorator for your resources.
#     Injects the app's `SQLAlchemy` object into the `ModelResource`,
#     such that DB queries can be conveniently made using `resource.orm`.
#     """
#
#     def wrapper(cls: R):
#         cls.db = db
#         return cls
#
#     return wrapper
