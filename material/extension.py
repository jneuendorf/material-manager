from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import DeclarativeMeta

from core.extension import Extension


class MaterialExtension(Extension):
    name = "material"

    def register_models(self, db: SQLAlchemy) -> dict:
        Model: DeclarativeMeta = db.Model

        class Material(Model):
            id = db.Column(db.Integer, primary_key=True)
            serial_number = db.Column(db.String)
            inventory_number = db.Column(db.String)
            manufacturer = db.Column(db.String)
            max_life_expectancy = db.Column(db.String)
            max_service_duration = db.Column(db.String)
            installation_date = db.Column(db.Date)
            instructions = db.Column(db.String)
            next_inspection_date = db.Column(db.Date)
            rental_fee = db.Column(db.String)
            condition = db.Column(db.String)
            usage_in_days = db.Column(db.Integer)

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
                "MaterialID",
                db.ForeignKey(Material.id),
                primary_key=True,
            ),
            db.Column(
                "PropertyID",
                db.ForeignKey(Property.id),
                primary_key=True,
            ),
        )

        return {
            "Material": Material,
            "PurchaseDetails": PurchaseDetails,
            "EquipmentType": EquipmentType,
            "Property": Property,
            "MaterialPropertyMapping": MaterialPropertyMapping,
        }
