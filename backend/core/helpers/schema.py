from collections.abc import Callable
from typing import (
    Any,
    Collection,
    Dict,
    Generic,
    Mapping,
    Optional,
    Type,
    TypeVar,
    Union,
)

from flask_marshmallow.sqla import SQLAlchemyAutoSchema
from marshmallow import fields
from marshmallow import types as ma_types
from marshmallow_sqlalchemy.convert import ModelConverter as BaseModelConverter
from marshmallow_sqlalchemy.schema import (
    SQLAlchemyAutoSchemaMeta,
    SQLAlchemyAutoSchemaOpts,
)
from sqlalchemy.sql import sqltypes

from core.helpers.fields import EnumField
from core.helpers.orm import CrudModel

M = TypeVar("M", bound=CrudModel)


class ModelConverter(BaseModelConverter):
    """Set up type overrides for UUID and enum.
    This takes care or setting up enum-serialization support. For details, see
    https://github.com/marshmallow-code/marshmallow-sqlalchemy/issues/112#issuecomment-1088328106
    """  # noqa"""

    SQLA_TYPE_MAPPING = {
        **BaseModelConverter.SQLA_TYPE_MAPPING,
        sqltypes.Enum: EnumField,
    }


class ModelMeta(SQLAlchemyAutoSchema.Meta, Generic[M]):
    model_converter: Type[ModelConverter]
    fields: Collection[str]
    model: Type[M]


class BaseSchemaMeta(SQLAlchemyAutoSchemaMeta):
    def __new__(mcs, name, bases, attrs):
        """Adds our custom model converter to the class.
        This way, we do not need to specify it in the schema's Meta class."""
        klass = super().__new__(mcs, name, bases, attrs)
        opts: SQLAlchemyAutoSchemaOpts = klass.opts
        opts.model_converter = ModelConverter
        opts.load_instance = True
        return klass

    @classmethod
    def get_declared_fields(
        mcs, klass: SQLAlchemyAutoSchemaMeta, cls_fields, inherited_fields, dict_cls
    ):
        """Returns all fields of the schema.

        Adds a static method `get_fields` to the schema class.
        This is necessary because the schema's `to_dict` method
        mutates the field instances. Thus, we need fresh copies each time.
        Therefore, we cannot use the schema class's `_declared_fields`.
        """

        def get_fields() -> Mapping[str, fields.Field]:
            return super(BaseSchemaMeta, mcs).get_declared_fields(
                klass, cls_fields, inherited_fields, dict_cls
            )

        setattr(klass, "get_fields", get_fields)
        declared_fields = super().get_declared_fields(
            klass, cls_fields, inherited_fields, dict_cls
        )
        return declared_fields


class BaseSchema(SQLAlchemyAutoSchema, Generic[M], metaclass=BaseSchemaMeta):
    Meta: Type[ModelMeta[M]]
    # Add type for method created by metaclass.
    get_fields: Callable[[], Mapping[str, fields.Field]]

    # For some reason mypy doesn't get the init arguments by itself.
    # So this is just a type hint.
    def __init__(
        self,
        *args,
        only: Optional[ma_types.StrSequenceOrSet] = None,
        exclude: ma_types.StrSequenceOrSet = (),
        many: Optional[bool] = False,
        context: Optional[dict] = None,
        load_only: ma_types.StrSequenceOrSet = (),
        dump_only: ma_types.StrSequenceOrSet = (),
        partial: Optional[Union[bool, ma_types.StrSequenceOrSet]] = False,
        unknown: Optional[str] = None,
        **kwargs,
    ):
        super().__init__(
            *args,
            only=only,
            exclude=exclude,
            many=many,
            context=context,
            load_only=load_only,
            dump_only=dump_only,
            partial=partial,
            unknown=unknown,
            **kwargs,
        )

    @classmethod
    def to_dict(
        cls, exclude=(), **field_options: Dict[str, Any]
    ) -> Dict[str, fields.Field]:
        """Returns the schema's fields as dictionary that can be used
        with `@use_kwargs`. The returned dictionary is new copy each call,
        so it can be mutated if needed.

        The `field_options` keyword arguments are of the form `name=options`
        For example for a schema

        >>> class Schema:
        >>>     name = fields.Str()
        >>>     description = fields.Str()

        this call

        >>> to_dict(name={"required": True}, description={"required": False})

        returns

        >>> {
        >>>     "name": fields.Str(required=True),
        >>>     "description": fields.Str(required=False),
        >>> }
        """

        def apply_field_options(field: fields.Field, options: Mapping[str, Any]):
            for key, value in options.items():
                setattr(field, key, value)
            return field

        declared_fields = cls.get_fields()
        return {
            field_name: apply_field_options(field, field_options.get(field_name, {}))
            for field_name, field in declared_fields.items()
            if field is not None and field_name not in exclude
        }
