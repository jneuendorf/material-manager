from collections.abc import Collection
from functools import cached_property
from typing import Generic, List, Type, TypeVar, Union

from flask_apispec import MethodResource
from flask_restful import Resource

from .orm import CrudModel
from .schema import BaseSchema

M = TypeVar("M", bound=CrudModel)


class BaseResource(MethodResource, Resource):
    url: Union[str, Collection[str]]


class ModelResource(BaseResource, Generic[M]):
    """Specifies how to serialize a model instance for each request type.

    Usage:

    >>> class MyResource(ModelResource):
    >>>     url = "/my_resource"
    >>>     class Schema:
    >>>         class Meta:
    >>>             model = MyModel
    >>>             fields = ("id", "name")
    """

    Schema: Type[BaseSchema[M]]

    @cached_property
    def schema(self) -> BaseSchema:
        return self.Schema(
            many=False,  # type: ignore
        )

    def serialize(self, instance: M):
        serialized: dict = self.schema.dump(instance)
        return serialized


class ModelListResource(ModelResource, Generic[M]):
    @cached_property
    def schema(self) -> BaseSchema:
        return self.Schema(
            many=True,  # type: ignore
        )

    def serialize(self, instance: M):
        serialized: List[dict] = self.schema.dump(instance)
        return serialized
