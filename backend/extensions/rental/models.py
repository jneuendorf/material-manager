import enum
from datetime import datetime
from typing import Type

from sqlalchemy import Table

from core.extensions import db
from core.helpers.orm import CrudModel

Model: Type[CrudModel] = db.Model


class RentalStatus(enum.Enum):
    LENT = "LENT"
    AVAILABLE = "AVAILABLE"
    UNAVAILABLE = "UNAVAILABLE"
    RETURNED = "RETURNED"


class Rental(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    # many to one (FK here)
    customer_id = db.Column(db.ForeignKey("user.id"))
    customer = db.relationship(
        "User",
        # foreign_keys=[db.Column("rental.customer_id")],
        backref="customer_rentals",
        primaryjoin="Rental.customer_id == User.id",
        uselist=False,
    )
    # many to one (FK here)
    lender_id = db.Column(db.ForeignKey("user.id"))
    lender = db.relationship(
        "User",
        backref="lender_rentals",
        primaryjoin="Rental.lender_id == User.id",
        uselist=False,
    )
    # many to one (FK here)
    return_to_id = db.Column(db.ForeignKey("user.id"))
    return_to = db.relationship(
        "User",
        backref="receiver_rentals",
        primaryjoin="Rental.return_to_id == User.id",
        uselist=False,
    )

    materials = db.relationship(
        "Material", secondary="material_rental_mapping", backref="rental"
    )

    rental_status = db.Column(
        db.Enum(RentalStatus, create_constraint=True),
        nullable=False,
        default=RentalStatus.AVAILABLE,
    )
    cost = db.Column(db.Float, nullable=False)
    discount = db.Column(db.Float, default=0)
    deposit = db.Column(db.Float, default=0)  # Kaution
    created_at = db.Column(db.DateTime, default=lambda: datetime.now())
    start_date = db.Column(db.Date, nullable=False)
    end_date = db.Column(db.Date, nullable=False)
    usage_start_date = db.Column(db.Date, nullable=True)
    usage_end_date = db.Column(db.Date, nullable=True)


MaterialRentalMapping: Table = db.Table(
    "material_rental_mapping",
    db.Column("rental_id", db.ForeignKey(Rental.id), primary_key=True),
    db.Column("material_id", db.ForeignKey("material.id"), primary_key=True),
)
