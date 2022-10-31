from flask_apispec import use_kwargs
from marshmallow import fields

from core.helpers.resource import ModelListResource, ModelResource, model_schema

from . import models

SerialNumberSchema = model_schema(
    models.SerialNumber,
    fields=["serial_number", "production_date", "manufacturer"],
    load_instance=True,  # Needed for model relationships
)


class MaterialType(ModelResource):
    url = "/material_type/<int:type_id>"

    class Meta:
        model = models.MaterialType
        fields = ("id", "name", "description")

    def get(self, type_id: int):
        """Test with
        curl -X GET "http://localhost:5000/material_type/1"
        """
        material_type = models.MaterialType.get(id=type_id)
        return self.serialize(material_type)


class MaterialTypes(ModelListResource):
    url = "/material_types"

    class Meta:
        model = models.MaterialType
        fields = ("id", "name", "description")

    def get(self):
        material_types = models.MaterialType.all()
        return self.serialize(material_types)

    @use_kwargs(
        {
            "name": fields.Str(required=True),
            "description": fields.Str(required=True),
        }
    )
    def put(self, **kwargs) -> dict:
        """Test with
        curl -X PUT "http://localhost:5000/material_types" -H 'Content-Type: application/json' -d '{"name":"Seile", "description":"Seil zum Klettern"}'
        """  # noqa
        material_type = models.MaterialType.create(**kwargs)
        return self.serialize_single(material_type)


class Material(ModelResource):
    url = "/material/<int:material_id>"

    class Meta:
        model = models.Material
        fields = (
            "id",
            "material_type_id",
            "inventory_number",
            "max_life_expectancy",
            "max_service_duration",
            "installation_date",
            "instructions",
            "next_inspection_date",
            "rental_fee",
            "condition",
            "days_used",
        )

    def get(self, material_id: int):
        """Test with
        curl -X GET "http://localhost:5000/material/1"
        """
        material = models.Material.get(id=material_id)
        return self.serialize(material)


# class PurchaseDetailsSchema(Schema):
#     purchase_date = fields.DateTime()
#     invoice_number = fields.Str()
#     merchant = fields.Str()
#     purchase_price = fields.Float()
#     suggested_retail_price = fields.Float()


class Materials(ModelListResource):
    url = "/materials"

    class Meta:
        model = models.Material
        fields = (
            "id",
            "material_type_id",
            "inventory_number",
            "max_life_expectancy",
            "max_service_duration",
            "installation_date",
            "instructions",
            "next_inspection_date",
            "rental_fee",
            "condition",
            "days_used",
        )

    def get(self):
        materials = models.Material.all()
        return self.serialize(materials)

    @use_kwargs(
        {
            "material_type_id": fields.Integer(),
            "inventory_number": fields.Str(),
            "max_life_expectancy": fields.Str(),
            "max_service_duration": fields.Str(),
            "installation_date": fields.Date(),
            "instructions": fields.Str(),
            "next_inspection_date": fields.Date(),
            "rental_fee": fields.Float(),
            "condition": fields.Enum(models.Condition),
            "days_used": fields.Integer(),
            "serial_numbers": fields.List(
                fields.Nested(
                    SerialNumberSchema(
                        # only=["serial_number", "production_date", "manufacturer"],
                    ),
                ),
                required=True,
            ),
            # "purchase_details": fields.Nested(PurchaseDetailsSchema(only=(
            # "purchase_date", "invoice_number", "merchant", "purchase_price",
            # "suggested_retail_price"))),
        }
    )
    def put(self, *, serial_numbers: list, **kwargs) -> dict:
        """Test with
        curl -X PUT 'http://localhost:5000/materials' -H 'Content-Type: application/json' -d '{
            "material_type_id":"2", "inventory_number":"56565656", "max_life_expectancy":"50",
            "max_service_duration":"20", "installation_date":"2014-12-22T03:12:58.019077+00:00",
            "instructions":"use it like this and that", "next_inspection_date":"2014-12-22T03:12:58.019077+00:00",
            "rental_fee":"20", "condition":"OK", "days_used":"5"}'
        """  # noqa
        material = models.Material.create(
            _related=dict(
                serial_numbers=serial_numbers,
            ),
            **kwargs,
        )
        return self.serialize_single(material)

    # curl -X PUT 'http://localhost:5000/material_types'
    # -H 'Content-Type: application/json' -d '{
    # "material_type_id":"2", "inventory_number":"56565656",
    # "max_life_expectancy":"50", "max_service_duration":"20",
    # "installation_date":"2014-12-22T03:12:58.019077+00:00",
    # "instructions":"use it like this and that",
    # "next_inspection_date":"2014-12-22T03:12:58.019077+00:00",
    # "rental_fee":"20", "condition":"OK", "days_used":"5",
    # "purchase_details": {"purchase_date":"2014-12-22T03:12:58.019077+00:00",
    # "invoice_number":"31", "merchant":"Merchentt bla",
    # "purchase_price":"55", "suggested_retail_price":"130" }}'
