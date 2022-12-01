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
    name = db.Column(db.String(length=32), unique=True)
    description = db.Column(db.String(length=80))
    sets = db.relationship(
        "MaterialSet",
        secondary="material_type_set_mapping",
        backref="material_types",
    )
    # many to many
    property_types = db.relationship(
        "PropertyType",
        secondary="material_type_property_type_mapping",
        backref="material_types",
    )


class PropertyType(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(length=32), unique=True)
    description = db.Column(db.String(length=80))
    unit = db.Column(db.String(length=12))

    __table_args__ = (
        UniqueConstraint(
            "name",
            "unit",
            name="name_unit_uc",
        ),
    )


class Property(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    # many to one (FK here)
    property_type_id = db.Column(db.ForeignKey(PropertyType.id), nullable=False)
    property_type = db.relationship("PropertyType", backref="properties")
    value = db.Column(db.String(length=32))

    __table_args__ = (
        UniqueConstraint(
            "property_type_id",
            "value",
            name="type_value_uc",
        ),
    )

    def __str__(self) -> str:
        unit = self.property_type.unit
        return (
            f"{self.property_type.name}: " f"{self.value}{' ' + unit if unit else ''}"
        )


MaterialTypePropertyTypeMapping: Table = db.Table(
    "material_type_property_type_mapping",
    db.Column("material_type_id", db.ForeignKey(MaterialType.id), primary_key=True),
    db.Column("property_type_id", db.ForeignKey(PropertyType.id), primary_key=True),
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
    name = db.Column(db.String(length=80), nullable=False)
    installation_date = db.Column(db.Date, nullable=True)  # Inbetriebnahme
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
    # one to many (FK on child)
    inventory_numbers = db.relationship("InventoryNumber", backref="material")
    # many to many
    images = db.relationship(
        "File",
        secondary="material_image_mapping",
    )
    # many to many
    properties = db.relationship(
        "Property",
        secondary="material_property_mapping",
        backref="materials",
    )

    @property
    def description(self):
        return f"{self.name} ({', '.join(str(prop) for prop in self.properties)})"

    def save(self) -> None:
        if not self.serial_numbers:
            raise ValueError("A material must have at least 1 associated serial number")
        super().save()


MaterialImageMapping: Table = db.Table(
    "material_image_mapping",
    db.Column("material_id", db.ForeignKey(Material.id), primary_key=True),
    db.Column("file_id", db.ForeignKey(File.id), primary_key=True),
)

MaterialPropertyMapping: Table = db.Table(
    "material_property_mapping",
    db.Column("material_id", db.ForeignKey(Material.id), primary_key=True),
    db.Column("property_id", db.ForeignKey(Property.id), primary_key=True),
)


class InventoryNumber(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    inventory_number = db.Column(db.String(length=20), nullable=False, unique=True)
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
    # many to many
    images = db.relationship(
        "File",
        secondary="material_set_image_mapping",
    )
    # images = File.reverse_generic_relationship("MaterialSet")
    name = db.Column(db.String(length=32))


MaterialSetImageMapping: Table = db.Table(
    "material_set_image_mapping",
    db.Column("material_set_id", db.ForeignKey(MaterialSet.id), primary_key=True),
    db.Column("file_id", db.ForeignKey(File.id), primary_key=True),
)

MaterialTypeSetMapping: Table = db.Table(
    "material_type_set_mapping",
    db.Column("material_set_id", db.ForeignKey(MaterialSet.id), primary_key=True),
    db.Column("material_type_id", db.ForeignKey(MaterialType.id), primary_key=True),
)
