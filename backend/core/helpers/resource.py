from collections.abc import Collection, Mapping
from functools import cached_property
from typing import Any, Dict, Generic, List, Type, TypeVar, Union

from flask_apispec import MethodResource
from flask_marshmallow.sqla import SQLAlchemyAutoSchema
from flask_restful import Resource
from marshmallow import fields
from marshmallow_sqlalchemy.convert import ModelConverter as BaseModelConverter
from sqlalchemy.sql import sqltypes

from .orm import CrudModel

M = TypeVar("M", bound=CrudModel)

"""The following 2 classes takes care or setting up enum-serialization support. See
https://github.com/marshmallow-code/marshmallow-sqlalchemy/issues/112#issuecomment-1088328106
for details.
"""  # noqa


class EnumField(fields.Field):
    """Marshmallow field for SQLA enum type.
    Using `fields.Enum` instead does NOT work.
    """

    def _serialize(self, value: Any, attr: str, obj: Any, **kwargs):
        """Serialize an enum type to a string"""
        try:
            return value.name
        except AttributeError:
            return value


class ModelConverter(BaseModelConverter):
    """Set up type overrides for UUID and enum."""

    SQLA_TYPE_MAPPING = {
        **BaseModelConverter.SQLA_TYPE_MAPPING,
        sqltypes.Enum: EnumField,
    }


class BaseResource(MethodResource, Resource):
    url: Union[str, Collection[str]]


# STUB TYPES FOR EASIER USAGE
class MetaStub(Generic[M]):
    """Contains model-related attrs and some types of SQLAlchemyAutoSchema.Meta"""

    model: Type[M]
    model_converter: Type[ModelConverter]
    fields: Collection[str]
    additional: Collection[str]
    include: Mapping[str, Any]
    exclude: Collection[str]
    dateformat: str
    datetimeformat: str
    timeformat: str
    ordered: bool
    load_only: Collection[str]
    dump_only: Collection[str]


class SchemaStub(Generic[M]):
    Meta: Type[MetaStub[M]]


class ModelMeta(SQLAlchemyAutoSchema.Meta, Generic[M]):
    model_converter: Type[ModelConverter]
    fields: Collection[str]
    model: Type[M]


class BaseSchema(SQLAlchemyAutoSchema, Generic[M]):
    Meta: Type[ModelMeta[M]]

    @classmethod
    def to_dict(cls) -> Dict[str, fields.Field]:
        return cls._declared_fields


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

    Schema: Type[SchemaStub[M]]

    @classmethod
    def completed_schema(cls, **kwargs) -> BaseSchema:
        """Extends Meta by:
        - model converter => enable enum support
        """

        class Schema(cls.Schema, BaseSchema):  # type: ignore
            class Meta(cls.Schema.Meta):  # type: ignore
                model_converter = ModelConverter

        return Schema(**kwargs)

    @cached_property
    def schema(self) -> BaseSchema:
        return self.completed_schema(many=False)

    def serialize(self, instance: M):
        serialized: dict = self.schema.dump(instance)
        return serialized


class ModelListResource(ModelResource, Generic[M]):
    @cached_property
    def schema(self) -> BaseSchema:
        return self.completed_schema(many=True)

    def serialize(self, instance: M):
        serialized: List[dict] = self.schema.dump(instance)
        return serialized

    def serialize_single(self, instance: M):
        serialized: dict = self.schema.dump(instance, many=False)
        return serialized
