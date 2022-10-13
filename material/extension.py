from typing import TypedDict

from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Table

from core.extension import Extension, ModelWithId, ModelWithIdType


class MaterialModels(TypedDict):
    Material: ModelWithIdType
    SerialNumber: ModelWithIdType
    PurchaseDetails: ModelWithIdType
    EquipmentType: ModelWithIdType
    Property: ModelWithIdType
    MaterialPropertyMapping: Table


class MaterialExtension(Extension[MaterialModels]):
    name = "material"

    def register_models(self, db: SQLAlchemy) -> MaterialModels:
        class Material(ModelWithId):
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

        class SerialNumber(ModelWithId):
            material_id = db.Column(db.ForeignKey(Material.id))
            manufacturer = db.Column(db.String)

        class PurchaseDetails(ModelWithId):
            material_id = db.Column(db.ForeignKey(Material.id))
            purchase_date = db.Column(db.Date)
            invoice_number = db.Column(db.String)
            merchant = db.Column(db.String)
            production_date = db.Column(db.Date)
            purchase_price = db.Column(db.Float)
            suggested_retail_price = db.Column(db.Float)

        class EquipmentType(ModelWithId):
            material_id = db.Column(db.ForeignKey(Material.id))
            description = db.Column(db.String)

        class Property(ModelWithId):
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

        return {
            "Material": Material,
            "SerialNumber": SerialNumber,
            "PurchaseDetails": PurchaseDetails,
            "EquipmentType": EquipmentType,
            "Property": Property,
            "MaterialPropertyMapping": MaterialPropertyMapping,
        }
