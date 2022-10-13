from typing import TypedDict

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Table

from core.extension import Data, Extension, ModelWithId, ModelWithIdType
from material.extension import MaterialModels
from user.extension import UserModels


class RentalModels(TypedDict):
    RentalStatus: ModelWithIdType
    Rental: ModelWithIdType
    MaterialRentalMapping: Table


class RentalExtension(Extension):
    name = "rental"
    dependencies = ["material", "user"]

    def register_models(self, app: Flask, db: SQLAlchemy) -> RentalModels:
        material: Data[MaterialModels] = app.extensions["material"]
        user: Data[UserModels] = app.extensions["user"]
        Material = material.models["Material"]
        User = user.models["User"]

        class RentalStatus(ModelWithId):
            Name = db.Column(db.String)

        class Rental(ModelWithId):
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
            return_to_id = db.Column(db.ForeignKey(User.id))

        MaterialRentalMapping = db.Table(
            "material_rental_mapping",
            db.Column("rental_id", db.ForeignKey(Rental.id), primary_key=True),
            db.Column("material_id", db.ForeignKey(Material.id), primary_key=True),
        )

        return {
            "RentalStatus": RentalStatus,
            "Rental": Rental,
            "MaterialRentalMapping": MaterialRentalMapping,
        }
