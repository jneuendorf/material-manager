import re
from collections.abc import Iterable
from typing import cast

from flask import Flask
from flask_apispec import FlaskApiSpec, MethodResource
from flask_restful import Api

from core.helpers import Extension


def install_extensions(
    app: Flask,
    api: Api,
    api_docs: FlaskApiSpec,
    base_url: str = "/",
) -> None:
    # Avoid cyclic imports at load-time
    from core.installed_extensions import extensions

    try:
        for extension in cast(Iterable[Extension], extensions):
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
    except Exception as e:
        print(str(e))
        print("Maybe you extensions have cyclic dependencies")
        raise e


def url_join(*parts: str) -> str:
    """For generating the resource URLs we cannot use urllib.parse.urljoin
    because that function requires the base url to contain the scheme etc.
    """

    return re.sub(r"/+", "/", "/".join(parts))
