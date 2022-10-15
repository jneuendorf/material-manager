from dataclasses import dataclass
from typing import NamedTuple

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import DeclarativeMeta

from core.helpers.extension import Extension
from extensions.material import MaterialExtension
from extensions.user import UserExtension


@dataclass
class InspectionModels:
    Inspection: DeclarativeMeta
    Comment: DeclarativeMeta


class InspectionResources(NamedTuple):
    ...


class InspectionExtension(Extension[InspectionModels, InspectionResources]):
    name = "inspection"
    material: MaterialExtension
    user: UserExtension

    def init_app(self, app: Flask) -> None:
        self.material = app.extensions["material"]
        self.user = app.extensions["user"]

    def register_models(self, db: SQLAlchemy):
        Model: DeclarativeMeta = db.Model

        class Inspection(Model):
            id = db.Column(db.Integer, primary_key=True)
            inspector_id = db.Column(
                db.ForeignKey(self.user.models.User.id)  # type: ignore
            )
            material_id = db.Column(
                db.ForeignKey(self.material.models.Material.id)  # type: ignore
            )
            date = db.Column(db.Date)
            type = db.Column(db.String)  # PSA- / Sichtprüfung

        class Comment(Model):
            id = db.Column(db.Integer, primary_key=True)
            inspection_id = db.Column(db.ForeignKey(Inspection.id))
            comment = db.Column(db.String)
            photo = db.Column(db.String)  # URL

        return InspectionModels(
            **{
                "Inspection": Inspection,
                "Comment": Comment,
            }
        )

    def get_resources(self, db: SQLAlchemy):
        return InspectionResources()
