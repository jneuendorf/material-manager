from dataclasses import dataclass
from typing import NamedTuple, Type

from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Table
from sqlalchemy.orm import DeclarativeMeta

from core.helpers import ModelListResource, ModelResource
from core.helpers.extension import Extension

from .resources.material import define_material_resources


@dataclass
class MaterialModels:
    Material: DeclarativeMeta
    SerialNumber: DeclarativeMeta
    PurchaseDetails: DeclarativeMeta
    EquipmentType: DeclarativeMeta
    Property: DeclarativeMeta
    MaterialPropertyMapping: Table


class MaterialResources(NamedTuple):
    MaterialResource: Type[ModelResource]
    MaterialListResource: Type[ModelListResource]


class MaterialExtension(Extension[MaterialModels, MaterialResources]):
    name = "material"

    def register_models(self, db: SQLAlchemy):
        Model: DeclarativeMeta = db.Model

        class Material(Model):
            id = db.Column(db.Integer, primary_key=True)
            serial_number = db.Column(db.String)
            inventory_number = db.Column(db.String)
            max_life_expectancy = db.Column(db.String)
            max_service_duration = db.Column(db.String)
            installation_date = db.Column(db.Date)
            instructions = db.Column(db.String)
            next_inspection_date = db.Column(db.Date)
            rental_fee = db.Column(db.Float)
            condition = db.Column(db.String)
            days_used = db.Column(db.Integer)

        class SerialNumber(Model):
            id = db.Column(db.Integer, primary_key=True)
            material_id = db.Column(db.ForeignKey(Material.id))
            manufacturer = db.Column(db.String)

        class PurchaseDetails(Model):
            id = db.Column(db.Integer, primary_key=True)
            material_id = db.Column(db.ForeignKey(Material.id))
            purchase_date = db.Column(db.Date)
            invoice_number = db.Column(db.String)
            merchant = db.Column(db.String)
            production_date = db.Column(db.Date)
            purchase_price = db.Column(db.Float)
            suggested_retail_price = db.Column(db.Float)

        class EquipmentType(Model):
            id = db.Column(db.Integer, primary_key=True)
            material_id = db.Column(db.ForeignKey(Material.id))
            description = db.Column(db.String)

        class Property(Model):
            id = db.Column(db.Integer, primary_key=True)
            name = db.Column(db.String)
            description = db.Column(db.String)
            value = db.Column(db.String)
            unit = db.Column(db.String)

        MaterialPropertyMapping = db.Table(
            "material_property_mapping",
            db.Column(
                "material_id",
                db.ForeignKey(Material.id),
                primary_key=True,
            ),
            db.Column(
                "property_id",
                db.ForeignKey(Property.id),
                primary_key=True,
            ),
        )

        return MaterialModels(
            **{
                "Material": Material,
                "SerialNumber": SerialNumber,
                "PurchaseDetails": PurchaseDetails,
                "EquipmentType": EquipmentType,
                "Property": Property,
                "MaterialPropertyMapping": MaterialPropertyMapping,
            }
        )

    def get_resources(self, db: SQLAlchemy):
        MaterialResource, MaterialListResource = define_material_resources(
            db, self.models.Material
        )
        return MaterialResources(
            MaterialResource=MaterialResource,
            MaterialListResource=MaterialListResource,
        )
