from typing import Type

from sqlalchemy import UniqueConstraint

from core.extensions import db
from core.helpers.orm import CrudModel
from extensions.common.models import File

Model: Type[CrudModel] = db.Model


class Inspection(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    date = db.Column(db.Date)
    type = db.Column(db.String)  # PSA- / Sichtprüfung
    # many to one (FK here)
    inspector_id = db.Column(db.ForeignKey("user.id"))
    inspector = db.relationship("User", backref="inspections")
    # one to many (FK on child)
    comments = db.relationship("Comment", backref="inspection")


class Comment(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    inspection_id = db.Column(db.ForeignKey(Inspection.id))
    # many to one (FK here)
    material_id = db.Column(db.ForeignKey("material.id"))
    material = db.relationship("Material", backref="comments")
    comment = db.Column(db.String)
    photo = File.reverse_generic_relationship("Comment", has_many=False)
    __table_args__ = (
        UniqueConstraint("inspection_id", "material_id", name="inspection_material_uc"),
    )
