from typing import Type

from core.app import db
from core.helpers.orm import CrudModel
from extensions.material.models import Material
from extensions.user.models import User

Model: Type[CrudModel] = db.Model


class Inspection(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    inspector_id = db.Column(db.ForeignKey(User.id))
    material_id = db.Column(db.ForeignKey(Material.id))
    date = db.Column(db.Date)
    type = db.Column(db.String)  # PSA- / Sichtprüfung


class Comment(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    inspection_id = db.Column(db.ForeignKey(Inspection.id))
    comment = db.Column(db.String)
    photo = db.Column(db.String)  # URL
