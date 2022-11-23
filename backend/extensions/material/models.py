import enum
from typing import Type

from sqlalchemy import Table
from sqlalchemy.schema import UniqueConstraint

from core.extensions import db
from core.helpers.orm import CrudModel
from extensions.common.models import File

Model: Type[CrudModel] = db.Model


class MaterialType(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, unique=True)
    description = db.Column(db.String(length=80))
    sets = db.relationship(
        "MaterialSet",
        secondary="material_type_set_mapping",
        backref="material_types",
    )


class PurchaseDetails(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    purchase_date = db.Column(db.Date)
    invoice_number = db.Column(db.String(length=32))
    merchant = db.Column(db.String(length=80))
    purchase_price = db.Column(db.Float)
    suggested_retail_price = db.Column(db.Float, nullable=True)
    __table_args__ = (
        UniqueConstraint(
            "merchant",
            "invoice_number",
            name="merchant_invoice_number_uc",
        ),
    )


class Condition(enum.Enum):
    OK = "OK"
    REPAIR = "REPAIR"
    BROKEN = "BROKEN"


class Material(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    inventory_numbers = db.relationship("InventoryNumber", backref="material")
    name = db.Column(db.String(length=80), nullable=False)
    installation_date = db.Column(db.Date, nullable=False)  # Inbetriebnahme
    max_operating_date = db.Column(db.Date, nullable=True)  # Lebensdauer ("MHD")
    max_days_used = db.Column(
        db.Integer,
        nullable=False,
    )  # maximale Gebrauchsdauer, compare to 'days_used'
    days_used = db.Column(db.Integer, nullable=False, default=0)
    instructions = db.Column(db.Text, nullable=False, default="")
    next_inspection_date = db.Column(db.Date, nullable=False)
    rental_fee = db.Column(db.Float, nullable=False)
    # We need `create_constraint=True` because SQLite doesn't support enums natively
    condition = db.Column(
        db.Enum(Condition, create_constraint=True),
        nullable=False,
        default=Condition.OK,
    )
    # many to one (FK here)
    material_type_id = db.Column(db.ForeignKey(MaterialType.id), nullable=False)
    material_type = db.relationship("MaterialType", backref="materials")
    # many to one (FK here)
    purchase_details_id = db.Column(db.ForeignKey(PurchaseDetails.id), nullable=True)
    purchase_details = db.relationship("PurchaseDetails", backref="materials")
    # one to many (FK on child)
    serial_numbers = db.relationship("SerialNumber", backref="material")
    images = File.reverse_generic_relationship("Material")
    # many to many
    properties = db.relationship(
        "Property",
        secondary="material_property_mapping",
        backref="materials",
    )

    def save(self) -> None:
        if not self.serial_numbers:
            raise ValueError("A material must have at least 1 associated serial number")
        super().save()


class InventoryNumber(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    inventory_number = db.Column(db.String(length=20), nullable=False)
    material_id = db.Column(db.ForeignKey(Material.id))


class SerialNumber(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    serial_number = db.Column(db.String(length=32))
    production_date = db.Column(db.Date)
    manufacturer = db.Column(db.String(length=80))
    material_id = db.Column(db.ForeignKey(Material.id))
    __table_args__ = (
        UniqueConstraint(
            "manufacturer",
            "serial_number",
            name="manufacturer_serial_number_uc",
        ),
    )


class MaterialSet(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    images = File.reverse_generic_relationship("MaterialSet")
    name = db.Column(db.String(length=32))


MaterialTypeSetMapping: Table = db.Table(
    "material_type_set_mapping",
    db.Column("material_set_id", db.ForeignKey(MaterialSet.id), primary_key=True),
    db.Column("material_type_id", db.ForeignKey(MaterialType.id), primary_key=True),
)


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
