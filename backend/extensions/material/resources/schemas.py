from marshmallow import fields

from core.helpers.extension import url_join
from core.helpers.schema import BaseSchema, ModelConverter

from .. import models
from ..config import STATIC_URL_PATH


class SerialNumberSchema(BaseSchema):
    class Meta:
        model = models.SerialNumber
        fields = ("serial_number", "production_date", "manufacturer")


class InventoryNumberSchema(BaseSchema):
    class Meta:
        model = models.InventoryNumber
        fields = ("id", "inventory_number")


class MaterialTypeSchema(BaseSchema):
    class Meta:
        model = models.MaterialType
        fields = ("id", "name", "description")
        # load_only = ("id",)


class PropertyTypeSchema(BaseSchema):
    class Meta:
        model = models.PropertyType
        fields = ("id", "name", "description", "unit")


class PropertySchema(BaseSchema):
    property_type = fields.Nested(PropertyTypeSchema())

    class Meta:
        model = models.Property
        fields = ("id", "property_type", "value")


class PurchaseDetailsSchema(BaseSchema):
    class Meta:
        model = models.PurchaseDetails
        fields = (
            "id",
            "purchase_date",
            "invoice_number",
            "merchant",
            "purchase_price",
            "suggested_retail_price",
        )


class MaterialSchema(BaseSchema):
    material_type = fields.Nested(MaterialTypeSchema())
    serial_numbers = fields.List(fields.Nested(SerialNumberSchema()))
    inventory_numbers = fields.List(fields.Nested(InventoryNumberSchema()))
    purchase_details = fields.Nested(PurchaseDetailsSchema())
    image_urls = fields.Method("get_image_urls")
    properties = fields.List(fields.Nested(PropertySchema()))

    class Meta:
        # TODO: specifying model_converter should not be necessary
        #  Check why the metaclass doesn't work
        model_converter = ModelConverter
        model = models.Material
        dump_only = ("id", "image_urls")

    def get_image_urls(self, obj: models.Material):
        return [url_join(STATIC_URL_PATH, image.path) for image in obj.images]
