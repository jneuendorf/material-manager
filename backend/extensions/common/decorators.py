from functools import wraps
from hashlib import sha1
from pathlib import Path
from typing import Optional, TypedDict

from marshmallow import Schema, fields

from .models import File


class FileSchema(Schema):
    base64 = fields.Str()
    filename = fields.Str()
    mime_type = fields.Str(required=False)


class FileDict(TypedDict):
    base64: str
    filename: str
    mime_type: str


def with_files(
    param: str,
    related_extension: str,
):
    def resource_decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            file_dicts: list[FileDict] = kwargs.pop(param)
            if any(
                ("base64" not in file_dict or "filename" not in file_dict)
                for file_dict in file_dicts
            ):
                raise TypeError(f"Invalid file dict in {file_dicts}")

            files: list[File] = []
            for file_dict in file_dicts:
                path = str(
                    Path(file_dict["filename"]).with_stem(
                        sha1(file_dict["base64"]).hexdigest()
                    )
                )
                file: Optional[File] = File.get_or_none(
                    related_extension=related_extension,
                    path=path,
                )
                if file is None:
                    files.append(
                        File.create_from_base64(
                            related_extension,
                            path,
                            base64=file_dict["base64"],
                            mime_type=file_dict.get("mime_type", ""),
                            description=file_dict["filename"],
                        )
                    )
            return func(*args, **{param: files, **kwargs})

        return wrapper

    return resource_decorator
