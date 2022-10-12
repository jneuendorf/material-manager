from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import DeclarativeMeta

from core.extension import Extension


class InspectionExtension(Extension):
    name = "inspection"
    dependencies = ["material", "user"]

    def register_models(self, db: SQLAlchemy, existing_models: dict) -> dict:
        Model: DeclarativeMeta = db.Model
        Material: DeclarativeMeta = existing_models["material"]["Material"]
        User: DeclarativeMeta = existing_models["user"]["User"]

        class Inspection(Model):
            id = db.Column(db.Integer, primary_key=True)
            inspector_id = db.Column(db.ForeignKey(User.id))  # type: ignore
            material_id = db.Column(db.ForeignKey(Material.id))  # type: ignore
            date = db.Column(db.Date)
            type = db.Column(db.String)  # PSA- / Sichtprüfung

        class Comment(Model):
            id = db.Column(db.Integer, primary_key=True)
            inspection_id = db.Column(db.ForeignKey(Inspection.id))
            comment = db.Column(db.String)
            photo = db.Column(db.String)  # URL

        return {
            "Inspection": Inspection,
            "Comment": Comment,
        }
