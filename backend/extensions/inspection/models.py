from typing import Type

from core.extensions import db
from core.helpers.orm import CrudModel

Model: Type[CrudModel] = db.Model


class Inspection(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    inspector_id = db.Column(db.ForeignKey("user.id"))
    material_id = db.Column(db.ForeignKey("material.id"))
    date = db.Column(db.Date)
    type = db.Column(db.String)  # PSA- / Sichtprüfung


class Comment(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    inspection_id = db.Column(db.ForeignKey(Inspection.id))
    comment = db.Column(db.String)
    photo = db.Column(db.String)  # URL
