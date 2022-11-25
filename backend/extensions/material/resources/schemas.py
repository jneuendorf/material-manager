from marshmallow import fields

from core.helpers.extension import url_join
from core.helpers.schema import BaseSchema, ModelConverter
from extensions.material import STATIC_URL_PATH, models


class SerialNumberSchema(BaseSchema):
    class Meta:
        model = models.SerialNumber
        fields = ("serial_number", "production_date", "manufacturer")


class InventoryNumberSchema(BaseSchema):
    class Meta:
        model = models.SerialNumber
        fields = ("id", "inventory_number")


class MaterialTypeSchema(BaseSchema):
    class Meta:
        model = models.MaterialType
        fields = ("id", "name", "description")


class MaterialPropertySchema(BaseSchema):
    class Meta:
        model = models.Property
        fields = ("id", "name", "description", "value", "unit")


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
    properties = fields.List(fields.Nested(MaterialPropertySchema()))

    class Meta:
        # TODO: specifying model_converter should not be necessary
        #  Check why the metaclass doesn't work
        model_converter = ModelConverter
        model = models.Material
        dump_only = ("id", "image_urls")

    def get_image_urls(self, obj: models.Material):
        return [url_join(STATIC_URL_PATH, image.path) for image in obj.images]
