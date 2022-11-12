from pathlib import Path
from typing import Optional, Type, cast

from flask import current_app
from sqlalchemy_utils import generic_relationship

from core.extensions import db
from core.helpers.extension import Extension
from core.helpers.orm import CrudModel

Model: Type[CrudModel] = db.Model

EXTENSIONS_DIR = Path(__file__).parent.parent.resolve(strict=True)


class File(Model):  # type: ignore
    """Stores file metadata and contains a generic relation to table row.
    Only works if the related table has a single-column primary key
    of type db.Integer!
    """

    id = db.Column(db.Integer, primary_key=True)
    path = db.Column(db.String(length=128))
    """The path is used by the extension to generate the URL.
    Usually, relative to the extension's static folder.
    """
    mime_type = db.Column(db.String(length=75))
    """Length to fit longest common MIME type for .pptx files:

    application/vnd.openxmlformats-officedocument.presentationml.presentation
    """
    description = db.Column(db.String(length=100), default="")
    """Can be used for e.g. <img alt="...">"""
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
        initiating_model_cls = cast(CrudModel, type(self.object))
        initiating_extension: Optional[Extension] = None
        for name, extension in current_app.extensions.items():
            for model_cls in getattr(extension, "models", []):
                if model_cls is initiating_model_cls:
                    initiating_extension = extension
                    break

        if not initiating_extension:
            print("WARNING: File model instance deleted from unknown source")
            return
        if not initiating_extension.static_folder:
            print("WARNING: File model instance deleted without a static folder")
            return

        super().delete()
        resolved_path = EXTENSIONS_DIR / initiating_extension.static_folder / self.path
        resolved_path.unlink()
