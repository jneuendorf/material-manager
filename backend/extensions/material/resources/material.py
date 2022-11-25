from typing import Optional

from flask import abort
from flask_apispec import use_kwargs
from marshmallow import fields
from sqlalchemy.exc import IntegrityError

from core.helpers.resource import ModelListResource, ModelResource
from extensions.material import models
from extensions.material.resources.schemas import MaterialSchema, PurchaseDetailsSchema


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
        serial_numbers: list[models.SerialNumber],
        properties: Optional[list[models.Property]] = None,
        # TODO: handle image uploads
        images: Optional[list[models.File]] = None,
        purchase_details: Optional[models.PurchaseDetails] = None,
        **kwargs,
    ) -> dict:
        related = dict(
            material_type=material_type,
            serial_numbers=serial_numbers,
        )
        if properties:
            related["properties"] = properties
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
        materials: list[models.Material],
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
