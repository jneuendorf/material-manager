import enum
from typing import Type

from sqlalchemy import Table

from core.extensions import db
from core.helpers.orm import CrudModel

Model: Type[CrudModel] = db.Model


# class RentalStatus(Model):  # type: ignore
#    id = db.Column(db.Integer, primary_key=True)
#    Name = db.Column(db.String)


class RentalStatus(enum.Enum):
    LENT = "LENT"
    AVAILABLE = "AVAILABLE"
    UNAVAILABLE = "UNAVAILABLE"
    RETURNED = "RETURNED"


class Rental(Model):  # type: ignore
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
    rental_status = db.Column(
        db.Enum(RentalStatus, create_constraint=True),
        nullable=False,
        default=RentalStatus.AVAILABLE,
    )


MaterialRentalMapping: Table = db.Table(
    "material_rental_mapping",
    db.Column("rental_id", db.ForeignKey(Rental.id), primary_key=True),
    db.Column("material_id", db.ForeignKey("material.id"), primary_key=True),
)
