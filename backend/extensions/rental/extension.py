from dataclasses import dataclass
from typing import NamedTuple

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Table
from sqlalchemy.orm import DeclarativeMeta

from backend.core.helpers.extension import Extension
from backend.extensions.material.extension import MaterialExtension
from backend.extensions.user.extension import UserExtension


@dataclass
class RentalModels:
    RentalStatus: DeclarativeMeta
    Rental: DeclarativeMeta
    MaterialRentalMapping: Table


class RentalResources(NamedTuple):
    ...


class RentalExtension(Extension[RentalModels, tuple]):
    name = "rental"
    material: MaterialExtension
    user: UserExtension

    def init_app(self, app: Flask) -> None:
        self.material = app.extensions["material"]
        self.user = app.extensions["user"]

    def register_models(self, db: SQLAlchemy) -> RentalModels:
        Model: DeclarativeMeta = db.Model
        Material = self.material.models.Material
        User = self.user.models.User

        class RentalStatus(Model):
            id = db.Column(db.Integer, primary_key=True)
            Name = db.Column(db.String)

        class Rental(Model):
            id = db.Column(db.Integer, primary_key=True)
            customer_id = db.Column(db.ForeignKey(User.id))  # type: ignore
            lender_id = db.Column(db.ForeignKey(User.id))  # type: ignore
            cost = db.Column(db.Float)
            deposit = db.Column(db.Float)  # Kaution
            rental_status_id = db.Column(db.ForeignKey(RentalStatus.id))
            created_at = db.Column(db.DateTime)
            start_date = db.Column(db.Date)
            end_date = db.Column(db.Date)
            usage_start_date = db.Column(db.Date)
            usage_end_date = db.Column(db.Date)
            return_to_id = db.Column(db.ForeignKey(User.id))  # type: ignore

        MaterialRentalMapping = db.Table(
            "material_rental_mapping",
            db.Column("rental_id", db.ForeignKey(Rental.id), primary_key=True),
            db.Column(
                "material_id",
                db.ForeignKey(Material.id),  # type: ignore
                primary_key=True,
            ),
        )

        return RentalModels(
            **{
                "RentalStatus": RentalStatus,
                "Rental": Rental,
                "MaterialRentalMapping": MaterialRentalMapping,
            }
        )

    def get_resources(self, db: SQLAlchemy):
        return RentalResources()
