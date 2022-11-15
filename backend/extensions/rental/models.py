import enum
from typing import Type

from sqlalchemy import Table

from core.extensions import db
from core.helpers.orm import CrudModel
from extensions.common.models import File

Model: Type[CrudModel] = db.Model


class RentalStatus(enum.Enum):
    LENT = "LENT"
    AVAILABLE = "AVAILABLE"
    UNAVAILABLE = "UNAVAILABLE"
    RETURNED = "RETURNED"


class Rental(Model):  # type: ignore

    __tablename__ = (
        "rental"  # funktioniert hier aus irgendeinem Grund. Liegt nicht am Import
    )

    id = db.Column(db.Integer, primary_key=True)
    customer_id = db.Column(db.ForeignKey("user.id"))
    lender_id = db.Column(db.ForeignKey("user.id"))
    # rental_status_id = db.Column(db.ForeignKey(RentalStatus.id))
    cost = db.Column(db.Float)
    discount = db.Column(db.Float)
    deposit = db.Column(db.Float)  # Kaution
    created_at = db.Column(db.DateTime)
    start_date = db.Column(db.Date)
    end_date = db.Column(db.Date)
    usage_start_date = db.Column(db.Date)
    usage_end_date = db.Column(db.Date)
    return_to_id = db.Column(db.ForeignKey("user.id"))
    # one to many (FK on child)
    return_infos = db.relationship("ReturnInfo", backref="rental")
    rental_status = db.Column(
        db.Enum(RentalStatus, create_constraint=True),
        nullable=False,
        default=RentalStatus.AVAILABLE,
    )


class ReturnInfo(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    comment = db.Column(db.Text)
    images = File.reverse_generic_relationship("ReturnInfo")
    rental_id = db.Column(db.ForeignKey(Rental.id))
    material_id = db.Column(db.ForeignKey("material.id"))


MaterialRentalMapping: Table = db.Table(
    "material_rental_mapping",
    db.Column("rental_id", db.ForeignKey(Rental.id), primary_key=True),
    db.Column("material_id", db.ForeignKey("material.id"), primary_key=True),
)
