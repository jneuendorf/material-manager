from typing import TypedDict

from flask import current_app
from flask_sqlalchemy import SQLAlchemy

from core.extension import Data, Extension, ModelWithId, ModelWithIdType
from material.extension import MaterialModels
from user.extension import UserModels


class InspectionModels(TypedDict):
    Inspection: ModelWithIdType
    Comment: ModelWithIdType


class InspectionExtension(Extension[InspectionModels]):
    name = "inspection"

    def register_models(self, db: SQLAlchemy) -> InspectionModels:
        material: Data[MaterialModels] = current_app.extensions["material"]
        user: Data[UserModels] = current_app.extensions["user"]

        class Inspection(ModelWithId):
            inspector_id = db.Column(db.ForeignKey(user.models["User"].id))
            material_id = db.Column(db.ForeignKey(material.models["Material"].id))
            date = db.Column(db.Date)
            type = db.Column(db.String)  # PSA- / Sichtprüfung

        class Comment(ModelWithId):
            inspection_id = db.Column(db.ForeignKey(Inspection.id))
            comment = db.Column(db.String)
            photo = db.Column(db.String)  # URL

        return {
            "Inspection": Inspection,
            "Comment": Comment,
        }
