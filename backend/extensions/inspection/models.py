import enum
from typing import Type

from core.extensions import db
from core.helpers.orm import CrudModel

Model: Type[CrudModel] = db.Model


class InspectionType(enum.Enum):
    NORMAL = "NORMAL"  # Sichtprüfung
    PSA = "PSA"


class Inspection(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    inspector_id = db.Column(db.ForeignKey("user.id"))
    material_id = db.Column(db.ForeignKey("material.id"))
    date = db.Column(db.Date)
    type = db.Column(db.Enum(InspectionType, create_constraint=True))
    comments = db.relationship(
        "Comment",
        backref="inspection",
    )


class Comment(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    comment = db.Column(db.Text)
    photo = db.Column(db.String(length=128))  # URL
    inspection_id = db.Column(db.ForeignKey(Inspection.id))
