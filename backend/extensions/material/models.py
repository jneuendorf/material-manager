from typing import Type

from sqlalchemy import Table

from core.db import db
from core.helpers.orm import CrudModel

Model: Type[CrudModel] = db.Model


class Material(Model):  # type: ignore
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


class SerialNumber(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    material_id = db.Column(db.ForeignKey(Material.id))
    manufacturer = db.Column(db.String)


class PurchaseDetails(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    material_id = db.Column(db.ForeignKey(Material.id))
    purchase_date = db.Column(db.Date)
    invoice_number = db.Column(db.String)
    merchant = db.Column(db.String)
    production_date = db.Column(db.Date)
    purchase_price = db.Column(db.Float)
    suggested_retail_price = db.Column(db.Float)


class EquipmentType(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    material_id = db.Column(db.ForeignKey(Material.id))
    description = db.Column(db.String)


class Property(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String)
    description = db.Column(db.String)
    value = db.Column(db.String)
    unit = db.Column(db.String)


MaterialPropertyMapping: Table = db.Table(
    "material_property_mapping",
    db.Column("material_id", db.ForeignKey(Material.id), primary_key=True),
    db.Column("property_id", db.ForeignKey(Property.id), primary_key=True),
)
