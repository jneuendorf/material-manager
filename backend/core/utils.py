import re
from collections.abc import Iterable
from typing import Collection, Type, cast

from flask import Flask
from flask_marshmallow import Marshmallow
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy

from backend.core.helpers import Extension, ModelResource


def install_extensions(
    extensions: Collection[Type[Extension]],
    app: Flask,
    db: SQLAlchemy,
    api: Api,
    ma: Marshmallow,
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
                urls = [
                    url_join(
                        base_url,
                        url.format(ext_name=extension.name),
                    )
                    for url in resource.urls
                ]
                api.add_resource(resource, *urls)
                print(f"URLs for {resource.__name__}: {str(urls)}")
    except Exception as e:
        print(str(e))
        print("Maybe you extensions have cyclic dependencies")
        raise e


def url_join(*parts: str) -> str:
    """For generating the resource URLs we cannot use urllib.parse.urljoin
    because that function requires the base url to contain the scheme etc.
    """

    return re.sub(r"/+", "/", "/".join(parts))
