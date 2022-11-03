from typing import List

from flask import abort
from flask_apispec import use_kwargs
from marshmallow import fields
from sqlalchemy.exc import IntegrityError

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
    def post(self, **kwargs) -> dict:
        """Test with
        curl -X POST "http://localhost:5000/material_types" -H 'Content-Type: application/json' -d '{"name":"Seile", "description":"Seil zum Klettern"}'
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
    def post(self, **kwargs) -> dict:
        """Test with
        curl -X POST "http://localhost:5000/purchase_details" -H 'Content-Type: application/json' -d '{
            "invoice_number": "2154325gu2345",
            "merchant": "Händler",
            "purchase_date": "2022-11-02",
            "purchase_price": 50,
            "suggested_retail_price": 1000
            }'
        """  # noqa
        purchase_detail = models.PurchaseDetails.create(**kwargs)
        return self.serialize(purchase_detail)


class MaterialSchema(BaseSchema):
    material_type_id = fields.Integer()
    material_type = fields.Nested(MaterialType.completed_schema())
    serial_numbers = fields.List(fields.Nested(SerialNumberSchema()))
    purchase_details_id = fields.Integer()
    purchase_details = fields.Nested(PurchaseDetails.completed_schema())

    class Meta:
        model_converter = ModelConverter
        model = models.Material
        load_instance = True
        # fields = (
        #     "id",
        #     "inventory_number",
        #     "max_life_expectancy",
        #     "max_service_duration",
        #     "installation_date",
        #     "instructions",
        #     "next_inspection_date",
        #     "rental_fee",
        #     "condition",
        #     "days_used",
        #     "material_type_id",
        #     "material_type",
        #     "purchase_details",
        #     "serial_numbers",
        # )
        load_only = ("material_type_id",)
        dump_only = ("id",)


class Material(ModelResource):
    url = [
        "/material",
        "/material/<int:material_id>",
    ]
    Schema = MaterialSchema

    def get(self, material_id: int):
        """Test with
        curl -X GET "http://localhost:5000/material/1"
        """
        material = models.Material.get(id=material_id)
        return self.serialize(material)

    @use_kwargs(MaterialSchema.to_dict())
    def post(
        self,
        *,
        serial_numbers: List[models.SerialNumber],
        purchase_details: models.PurchaseDetails = None,
        **kwargs,
    ) -> dict:
        related = {"serial_numbers": serial_numbers}
        if purchase_details:
            related["purchase_details"] = purchase_details
        try:
            material = models.Material.create(
                _related=related,
                **kwargs,
            )
        except IntegrityError as e:
            print(e)
            abort(403, "Duplicate serial number for the same manufacturer")

        return self.serialize(material)


class Materials(ModelListResource):
    url = "/materials"
    Schema = MaterialSchema

    def get(self):
        materials = models.Material.all()
        return self.serialize(materials)
