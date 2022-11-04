from typing import Any

from marshmallow import fields


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
