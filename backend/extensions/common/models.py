from pathlib import Path
from typing import Type

from sqlalchemy_utils import generic_relationship

from core.extensions import db
from core.helpers.orm import CrudModel

Model: Type[CrudModel] = db.Model


class File(Model):  # type: ignore
    """Stores file metadata and contains a generic relation to table row.
    Only works if the related table has a single-column primary key
    of type db.Integer!
    """

    id = db.Column(db.Integer, primary_key=True)
    path = db.Column(db.String(length=128))
    filename = db.Column(db.String(length=255))
    # PPTX: application/vnd.openxmlformats-officedocument.presentationml.presentation
    mime_type = db.Column(db.String(length=75))
    # Can be used for e.g. <img alt="...">
    description = db.Column(db.String(length=100), default="")
    object_type = db.Column(db.String(length=255))
    object_id = db.Column(db.Integer)
    object = generic_relationship(object_type, object_id)

    @staticmethod
    def reverse_generic_relationship(from_model: str, has_many: bool = True):
        return db.relationship(
            File,
            foreign_keys=[File.object_id],
            primaryjoin=(
                "and_("
                f"File.object_type == '{from_model}', "
                f"File.object_id == {from_model}.id"
                ")"
            ),
            viewonly=True,
            uselist=has_many,
        )

    def delete(self) -> None:
        super().delete()
        Path(self.path).unlink()
