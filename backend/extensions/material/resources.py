from typing import List

from flask_apispec import use_kwargs
from marshmallow import fields
from marshmallow_sqlalchemy.fields import Nested

from core.helpers.resource import (
    BaseSchema,
    ModelConverter,
    ModelListResource,
    ModelResource,
)

from . import models


class SerialNumberSchema(BaseSchema):
    class Meta:
        model = models.SerialNumber
        fields = ("serial_number", "production_date", "manufacturer")
        load_instance = True


class MaterialType(ModelResource):
    url = "/material_type/<int:type_id>"

    class Schema:
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

    class Schema:
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


class PurchaseDetails(ModelResource):
    url = "/purchase_details"

    class Schema:
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

    @use_kwargs(
        {
            "purchase_date": fields.Date(required=True),
            "invoice_number": fields.Str(required=True),
            "merchant": fields.Str(),
            "purchase_price": fields.Float(),
            "suggested_retail_price": fields.Float(),
        }
    )
    def put(self, **kwargs) -> dict:
        """Test with
        curl -X PUT "http://localhost:5000/purchase_details" -H 'Content-Type: application/json' -d '{
            "invoice_number": "2154325gu2345",
            "merchant": "Händler",
            "purchase_date": "2022-11-02",
            "purchase_price": 50,
            "suggested_retail_price": 1000
            }'
        """  # noqa
        purchase_detail = models.PurchaseDetails.create(**kwargs)
        return self.serialize(purchase_detail)


class Material(ModelResource):
    url = "/material/<int:material_id>"

    class Schema:
        material_type = Nested(MaterialType.completed_schema())
        serial_numbers = Nested(
            SerialNumberSchema(),
            many=True,
        )

        class Meta:
            model = models.Material
            model_converter = ModelConverter
            fields = (
                "id",
                "inventory_number",
                "max_life_expectancy",
                "max_service_duration",
                "installation_date",
                "instructions",
                "next_inspection_date",
                "rental_fee",
                "condition",
                "days_used",
                "material_type",
                "serial_numbers",
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

    class Schema:
        class Meta:
            model = models.Material
            fields = (
                "id",
                "inventory_number",
                "max_life_expectancy",
                "max_service_duration",
                "installation_date",
                "instructions",
                "next_inspection_date",
                "rental_fee",
                "condition",
                "days_used",
                # "material_type",
                # "serial_numbers",
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
    def put(self, *, serial_numbers: List[models.SerialNumber], **kwargs) -> dict:
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
