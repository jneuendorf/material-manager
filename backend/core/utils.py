from collections.abc import Collection, Iterable
from typing import Type, cast

from flask import Flask
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy

from backend.core.helpers import Extension, ModelResource


def install_extensions(
    extensions: Collection[Type[Extension]],
    app: Flask,
    db: SQLAlchemy,
    api: Api,
    base_url: str = "/",
) -> None:
    try:
        for extension_cls in extensions:
            extension = extension_cls(app, db)
            resources = cast(
                Iterable[Type[ModelResource]],
                extension.resources,
            )
            for resource in resources:
                api.add_resource(
                    resource,
                    *[url_join(base_url, extension.name, url) for url in resource.urls],
                )
    except Exception as e:
        print(str(e))
        print("Maybe you extensions have cyclic dependencies")
        raise e


def url_join(*parts: str) -> str:
    """For generating the resource URLs we cannot use urllib.parse.urljoin
    because that function requires the base url to contain the scheme etc.
    """

    return "/".join(part.lstrip("/").rstrip("/") for part in parts)
