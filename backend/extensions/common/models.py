import mimetypes
from pathlib import Path
from typing import Type

from sqlalchemy_utils import generic_relationship

from core.extensions import db
from core.helpers.extension import get_extension
from core.helpers.orm import CrudModel

Model: Type[CrudModel] = db.Model

EXTENSIONS_DIR = Path(__file__).parent.parent.resolve(strict=True)


class File(Model):  # type: ignore
    """Stores file metadata and contains a generic relation to table row.
    Only works if the related table has a single-column primary key
    of type db.Integer!
    """

    id = db.Column(db.Integer, primary_key=True)
    path = db.Column(db.String(length=128), nullable=False, unique=True)
    """The path where the file is stored.
    It is relative to the extension's static folder.
    """
    mime_type = db.Column(db.String(length=75), default="")
    """Length to fit longest common MIME type for .pptx files:

    application/vnd.openxmlformats-officedocument.presentationml.presentation
    """
    description = db.Column(db.String(length=100), default="")
    """Can be used for e.g. <img alt="...">"""
    object_type = db.Column(db.String(length=255), nullable=False)
    object_id = db.Column(db.Integer, nullable=False)
    object = generic_relationship(object_type, object_id)

    @classmethod
    def reverse_generic_relationship(cls, from_model: str, has_many: bool = True):
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

    def download(self, url: str, force: bool = False):
        """Downloads the file from the given URL and saves it according to
        this instance's path.
        WORKS ONLY WHEN DEVELOPMENT REQUIREMENTS ARE INSTALLED!
        """

        path = self.resolved_path
        if force or not path.exists():
            from gdown import download

            download(
                url,
                output=str(path),
                quiet=False,
                fuzzy=True,
            )

            mime_type, _ = mimetypes.guess_type(path)
            if mime_type != self.mime_type:
                self.update(mime_type=mime_type)
                print(f"Updated MIME type after download from {url}")

    @property
    def resolved_path(self) -> Path:
        extension = get_extension(instance=self.object)
        if extension is None:
            raise TypeError(f"Could not find a extension that belongs to {self.object}")
        return (EXTENSIONS_DIR / extension.static_folder / self.path).resolve()

    def delete(self) -> None:
        initiating_extension = get_extension(instance=self.object)
        if initiating_extension is None:
            raise TypeError(f"Could not find a extension that belongs to {self.object}")
        if not initiating_extension.static_folder:
            print("WARNING: File instance deleted without a static folder")
            return

        super().delete()
        path = self.resolved_path
        if not path.exists():
            print("WARNING: File instance's path does not exist")
        self.resolved_path.unlink(missing_ok=True)
