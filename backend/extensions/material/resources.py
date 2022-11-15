from typing import List

from flask import abort
from flask_apispec import use_kwargs
from marshmallow import fields
from sqlalchemy.exc import IntegrityError

from core.helpers.extension import url_join
from core.helpers.resource import ModelListResource, ModelResource
from core.helpers.schema import BaseSchema, ModelConverter

from . import models
from .config import STATIC_URL_PATH


class SerialNumberSchema(BaseSchema):
    class Meta:
        model = models.SerialNumber
        fields = ("serial_number", "production_date", "manufacturer")


class MaterialTypeSchema(BaseSchema):
    class Meta:
        model = models.MaterialType
        fields = ("id", "name", "description")


class MaterialPropertySchema(BaseSchema):
    class Meta:
        model = models.Property
        fields = ("id", "name", "description", "value", "unit")


class MaterialType(ModelResource):
    url = [
        "/material_type",
        "/material_type/<int:type_id>",
    ]
    Schema = MaterialTypeSchema

    def get(self, type_id: int):
        """Test with
        curl -X GET "http://localhost:5000/material_type/1"
        """
        material_type = models.MaterialType.get(id=type_id)
        return self.serialize(material_type)

    @use_kwargs(
        MaterialTypeSchema.to_dict(
            name=dict(required=True),
            description=dict(required=True),
        )
    )
    def post(self, **kwargs) -> dict:
        """Test with
        curl -X POST "http://localhost:5000/material_type" \
        -H 'Content-Type: application/json' \
        -d '{"name":"Seile", "description":"Seil zum Klettern"}'
        """
        material_type = models.MaterialType.create(**kwargs)
        return self.serialize(material_type)


class MaterialTypes(ModelListResource):
    url = "/material_types"
    Schema = MaterialTypeSchema

    def get(self):
        material_types = models.MaterialType.all()
        return self.serialize(material_types)


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
    # material_type_id = fields.Integer()
    material_type = fields.Nested(MaterialTypeSchema())
    serial_numbers = fields.List(fields.Nested(SerialNumberSchema()))
    # purchase_details_id = fields.Integer()
    purchase_details = fields.Nested(PurchaseDetailsSchema())
    image_urls = fields.Method("get_image_urls")
    properties = fields.List(fields.Nested(MaterialPropertySchema()))

    class Meta:
        # TODO: specifying model_converter should not be necessary
        #  Check why the metaclass doesn't work
        model_converter = ModelConverter
        model = models.Material
        # load_only = ("material_type_id",)
        dump_only = ("id", "image_urls")

    def get_image_urls(self, obj: models.Material):
        return [url_join(STATIC_URL_PATH, image.path) for image in obj.images]


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

    @use_kwargs(MaterialSchema.to_dict(exclude=["image_urls"]))
    def post(
        self,
        *,
        material_type: models.MaterialType,
        serial_numbers: List[models.SerialNumber],
        properties: List[models.Property],
        # TODO: handle image uploads
        images: List[models.File] = None,
        purchase_details: models.PurchaseDetails = None,
        **kwargs,
    ) -> dict:
        related = dict(
            material_type=material_type,
            serial_numbers=serial_numbers,
            properties=properties,
        )
        if images:
            related["images"] = images
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

        return self.serialize(material)  # noqa


class Materials(ModelListResource):
    url = "/materials"
    Schema = MaterialSchema

    def get(self):
        materials = models.Material.all()
        return self.serialize(materials)

    @use_kwargs(
        {
            "materials": fields.List(
                fields.Nested(MaterialSchema(exclude=["id", "purchase_details"]))
            ),
            "purchase_details": fields.Nested(PurchaseDetailsSchema()),
        }
    )
    def post(
        self,
        materials: List[models.Material],
        purchase_details: models.PurchaseDetails,
    ):
        """Saves a purchase: Many materials + purchase details"""
        purchase_details.save()
        for material in materials:
            material.purchase_details = purchase_details
            material.save()
        # TODO: What data does the FE need here?
        return {
            "materials": [material.id for material in materials],
        }
