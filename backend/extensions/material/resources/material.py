from datetime import date
from typing import Optional

from flask import abort
from flask_apispec import use_kwargs
from marshmallow import fields
from sqlalchemy.exc import IntegrityError

from core.helpers.resource import ModelListResource, ModelResource
from extensions.common.decorators import FileSchema, with_files
from extensions.common.models import File
from extensions.material import models
from extensions.material.resources.schemas import (
    InventoryNumberSchema,
    MaterialSchema,
    SerialNumberSchema,
)


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
            "serial_numbers": fields.List(
                fields.List(
                    fields.Nested(SerialNumberSchema()),
                ),
            ),
            "inventory_numbers": fields.List(
                fields.Nested(InventoryNumberSchema(exclude=["id"])),
            ),
            "images": fields.List(
                fields.Nested(FileSchema()),
            ),
            **MaterialSchema.to_dict(
                include=[
                    "material_type",
                    "purchase_details",
                    "properties",
                    "max_operating_date",
                    "max_days_used",
                    "instructions",
                    "next_inspection_date",
                    "rental_fee",
                ],
            ),
        }
    )
    @with_files("images", related_extension="material")
    def post(
        self,
        material_type: models.MaterialType,
        serial_numbers: list[list[models.SerialNumber]],
        inventory_numbers: list[models.InventoryNumber],
        purchase_details: models.PurchaseDetails,
        images: list[File],
        max_operating_date: date,
        max_days_used: int,
        instructions: str,
        next_inspection_date: date,
        rental_fee: float,
        properties: list[models.Property],
    ):
        """Saves a batch of materials that share some identical data. I.e.
        - purchase details
        - material type
        - images
        """

        if len(serial_numbers) != len(inventory_numbers):
            return abort(
                400,
                "number of serial numbers does not match number of inventory numbers",
            )

        for prop in properties:
            prop.ensure_saved()
        material_type = material_type.ensure_saved()
        purchase_details = purchase_details.ensure_saved()
        if material_type.id is None or purchase_details.id is None:
            return abort(
                500,
                "error while trying to persist material type or purchase details",
            )

        try:
            for serial_nums, inventory_num in zip(serial_numbers, inventory_numbers):
                material = models.Material.create(
                    name="",
                    installation_date=None,
                    max_operating_date=max_operating_date,
                    max_days_used=max_days_used,
                    instructions=instructions,
                    next_inspection_date=next_inspection_date,
                    rental_fee=rental_fee,
                    _related=dict(
                        material_type=material_type,
                        purchase_details=purchase_details,
                        serial_numbers=list(serial_nums),
                        inventory_numbers=[inventory_num],
                        images=images,
                        properties=properties,
                    ),
                )
                print(material)
        except Exception as e:
            print(e)
            return abort(500, "unknown error")

        return {"success": True}
