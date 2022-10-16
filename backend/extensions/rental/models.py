from typing import Type

from sqlalchemy import Table

from core.app import db
from core.helpers.orm import CrudModel
from extensions.material.models import Material
from extensions.user.models import User

Model: Type[CrudModel] = db.Model


class RentalStatus(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    Name = db.Column(db.String)


class Rental(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    customer_id = db.Column(db.ForeignKey(User.id))
    lender_id = db.Column(db.ForeignKey(User.id))
    cost = db.Column(db.Float)
    deposit = db.Column(db.Float)  # Kaution
    rental_status_id = db.Column(db.ForeignKey(RentalStatus.id))
    created_at = db.Column(db.DateTime)
    start_date = db.Column(db.Date)
    end_date = db.Column(db.Date)
    usage_start_date = db.Column(db.Date)
    usage_end_date = db.Column(db.Date)
    return_to_id = db.Column(db.ForeignKey(User.id))  # type: ignore


MaterialRentalMapping: Table = db.Table(
    "material_rental_mapping",
    db.Column("rental_id", db.ForeignKey(Rental.id), primary_key=True),
    db.Column("material_id", db.ForeignKey(Material.id), primary_key=True),
)
