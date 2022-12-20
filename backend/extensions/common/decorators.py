from base64 import b64decode
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


def file_from_file_dict(file_dict: FileDict, related_extension: str) -> File:
    data = b64decode(file_dict["base64"])
    path = str(Path(file_dict["filename"]).with_stem(sha1(data).hexdigest()))
    file: Optional[File] = File.get_or_none(
        related_extension=related_extension,
        path=path,
    )
    return file or File.get_or_create_from_base64(
        related_extension,
        data,
        path,
        mime_type=file_dict.get("mime_type", ""),
        description=file_dict["filename"],
    )


def with_file(
    param: str,
    related_extension: str,
):
    def resource_decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            file_dict: FileDict = kwargs.pop(param)
            if any(("base64" not in file_dict or "filename" not in file_dict)):
                raise TypeError("Invalid file dict")
            return func(
                *args,
                **{
                    param: file_from_file_dict(file_dict, related_extension),
                    **kwargs,
                },
            )

        return wrapper

    return resource_decorator


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
            return func(
                *args,
                **{
                    param: [
                        file_from_file_dict(file_dict, related_extension)
                        for file_dict in file_dicts
                    ],
                    **kwargs,
                },
            )

        return wrapper

    return resource_decorator
