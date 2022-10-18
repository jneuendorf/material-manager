import re
from typing import TYPE_CHECKING

from flask import Flask
from flask_apispec import FlaskApiSpec, MethodResource
from flask_restful import Api

if TYPE_CHECKING:
    from core.helpers.extension import Extension


def install_extension(
    extension: "Extension",
    app: Flask,
    api: Api,
    api_docs: FlaskApiSpec,
    base_url: str = "/",
) -> None:
    app.register_blueprint(extension)
    for resource in extension.resources:
        urls = [
            url_join(base_url, url.format(ext_name=extension.name))
            for url in ([resource.url] if resource.url else resource.urls)
        ]
        api.add_resource(resource, *urls)
        print(f"URLs for {resource.__name__}: {str(urls)}")
        if issubclass(resource, MethodResource):
            api_docs.register(resource)


def url_join(*parts: str) -> str:
    """For generating the resource URLs we cannot use urllib.parse.urljoin
    because that function requires the base url to contain the scheme etc.
    """

    return re.sub(r"/+", "/", "/".join(parts))
