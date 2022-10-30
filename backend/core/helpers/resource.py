from collections.abc import Collection
from functools import cached_property
from typing import Any, Generic, List, Optional, Type, TypeVar

from flask_apispec import MethodResource
from flask_marshmallow.sqla import SQLAlchemyAutoSchema
from flask_restful import Resource
from marshmallow import Schema, fields
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
    """Resources without a URL are not"""

    url: Optional[str] = None


class ModelMeta(SQLAlchemyAutoSchema.Meta, Generic[M]):
    model_converter = Type[BaseModelConverter]
    fields: Collection[str]
    model: Type[M]


class ModelMetaSchema(SQLAlchemyAutoSchema, Schema, Generic[M]):
    Meta: Type[ModelMeta[M]]


def model_schema(
    model: Type[M],
    fields: Collection[str],
    **kwargs,
) -> Type[ModelMetaSchema[M]]:
    """
    For details about options see
    https://marshmallow-sqlalchemy.readthedocs.io/en/latest/api_reference.html#marshmallow_sqlalchemy.SQLAlchemySchema.OPTIONS_CLASS
    """  # noqa

    class Schema(ModelMetaSchema):
        Meta = type(
            "Meta",
            (),
            dict(
                model=model,
                fields=fields,
                **kwargs,
            ),
        )

    return Schema


class ModelResource(BaseResource, Generic[M]):
    """Specifies how to serialize a model instance for each request type.

    Usage:

    >>> class MyResource(ModelResource):
    >>>     url = "/my_resource"
    >>>     class Meta:
    >>>         model = MyModel
    >>>         fields = ("id", "name")
    """

    url: str
    Meta: Type[ModelMeta[M]]
    _schema_cls: Optional[Type[ModelMetaSchema]] = None

    @classmethod
    def get_schema(cls, **kwargs) -> ModelMetaSchema:
        """Wraps this resource's Meta class with a marshmallow schema
        and enables support for enums.
        """

        if not cls._schema_cls:

            class Schema(ModelMetaSchema):
                class Meta(cls.Meta):  # type: ignore
                    model_converter = ModelConverter

            cls._schema_cls = Schema
        return cls._schema_cls(**kwargs)

    @cached_property
    def schema(self) -> ModelMetaSchema:
        return self.get_schema(many=False)

    def serialize(self, instance: M):
        serialized: dict = self.schema.dump(instance)
        return serialized


class ModelListResource(ModelResource, Generic[M]):
    @cached_property
    def schema(self) -> ModelMetaSchema:
        return self.get_schema(many=True)

    def serialize(self, instance: M):
        serialized: List[dict] = self.schema.dump(instance)
        return serialized

    def serialize_single(self, instance: M):
        serialized: dict = self.schema.dump(instance, many=False)
        return serialized
