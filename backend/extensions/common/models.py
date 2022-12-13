import mimetypes
from hashlib import sha1
from pathlib import Path
from typing import Optional, Type

from PIL import Image
from PIL.ImageOps import exif_transpose
from sqlalchemy import UniqueConstraint

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
    related_extension = db.Column(db.String(length=64), nullable=False)
    path = db.Column(db.String(length=128), nullable=False)
    """The path where the file is stored.
    It is relative to the extension's static folder.
    """
    mime_type = db.Column(db.String(length=75), default="")
    """Length to fit longest common MIME type for .pptx files:
    application/vnd.openxmlformats-officedocument.presentationml.presentation
    """
    description = db.Column(db.String(length=100), default="")
    """Can be used for e.g. <img alt="...">"""
    is_thumbnail = db.Column(db.Boolean(create_constraint=True), default=False)

    __table_args__ = (
        UniqueConstraint(
            "related_extension",
            "path",
            name="related_extension_path_uc",
        ),
    )

    @classmethod
    def get_or_create_from_base64(
        cls,
        related_extension: str,
        data: bytes,
        path: Optional[str] = None,
        mime_type: str = "",
        description: str = "",
        is_thumbnail: bool = False,
    ) -> "File":
        if path is None:
            extension = mimetypes.guess_extension(mime_type)
            if extension is None:
                raise ValueError(
                    "Could not determine file path because it is not given "
                    "nor is the MIME type"
                )
            path = str(sha1(data).hexdigest() + extension)
        file: File = cls.get_or_create(
            related_extension=related_extension,
            path=path,
            mime_type=mime_type if mime_type else mimetypes.guess_type(path),
            description=description,
            is_thumbnail=is_thumbnail,
        )
        resolved_path = file.resolved_path
        # Avoid FileNotFoundError, see https://stackoverflow.com/a/2401655/6928824
        resolved_path.parent.mkdir(parents=True, exist_ok=True)
        resolved_path.write_bytes(data)
        return file

    def download(
        self,
        url: str,
        resize: Optional[tuple[int, int]] = None,
        force: bool = False,
    ) -> "File":
        """Downloads the file from the given URL and saves it according to
        this instance's path.
        WORKS ONLY WHEN DEVELOPMENT REQUIREMENTS ARE INSTALLED!
        """

        path = self.resolved_path
        path.parent.mkdir(parents=True, exist_ok=True)
        if force or not path.exists():
            from gdown import download

            download(
                url,
                output=str(path),
                quiet=False,
                fuzzy=True,
            )
            if resize:
                with Image.open(path) as im:
                    exif_transpose(im).resize(resize).save(
                        path, icc_profile=im.info.get("icc_profile")
                    )

            mime_type, _ = mimetypes.guess_type(path)
            if mime_type != self.mime_type:
                self.update(mime_type=mime_type)
                print(f"Updated MIME type after download from {url}")

        return self

    @property
    def resolved_path(self) -> Path:
        extension = get_extension(extension_name=self.related_extension)
        if extension is None:
            raise ValueError(f"Could not find a extension that belongs to {self}")
        if not extension.static_folder:
            raise ValueError(f"Extension {self.related_extension} has no static folder")
        return (EXTENSIONS_DIR / extension.static_folder / self.path).resolve()

    def delete(self) -> None:
        super().delete()
        path = self.resolved_path
        if not path.exists():
            print("WARNING: File instance's path does not exist")
        else:
            path.unlink(missing_ok=True)
