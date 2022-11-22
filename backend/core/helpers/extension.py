import re
from abc import ABC
from collections.abc import Iterable, Mapping
from typing import Any, Generic, Optional, Type, TypeVar, Union

from flask import Blueprint, Flask, current_app
from flask_apispec import FlaskApiSpec, MethodResource
from flask_jwt_extended import JWTManager
from flask_restful import Api
from sqlalchemy import Table

from .orm import CrudModel
from .resource import BaseResource

M = TypeVar("M", bound=Iterable[Union[Type[CrudModel], Table]])
R = TypeVar("R", bound=Iterable[Type[BaseResource]])


def url_join(*parts: str) -> str:
    """For generating the resource URLs we cannot use urllib.parse.urljoin
    because that function requires the base url to contain the scheme etc.
    """

    return re.sub(r"/+", "/", "/".join(parts))


def get_extension(instance: CrudModel) -> "Optional[Extension]":
    model_cls = type(instance)
    for name, extension in current_app.extensions.items():
        for extension_model_cls in getattr(extension, "models", []):
            if extension_model_cls is model_cls:
                return extension
    return None


class Extension(Blueprint, ABC, Generic[M, R]):
    models: M = ()  # type: ignore
    resources: R = ()  # type: ignore
    permissions: Iterable[Mapping[str, str]] = ()

    def __init__(
        self,
        name: str,
        import_name: str,
        models: Optional[M] = None,
        resources: Optional[R] = None,
        permissions: Optional[Iterable[Mapping[str, str]]] = None,
        **kwargs,
    ):
        super().__init__(name, import_name, **kwargs)
        # Allow setting the attributes on the class when both subclassing
        # and instantiating Extension directly.
        if models is not None:
            self.models = models
        if resources is not None:
            self.resources = resources
        if permissions is not None:
            self.permissions = permissions

    def install(
        self,
        app: Flask,
        jwt: JWTManager,
        api: Api,
        api_docs: FlaskApiSpec,
        base_url: str = "/",
        **blueprint_options: Any,
    ) -> None:
        self.before_install(app=app, jwt=jwt, api=api, api_docs=api_docs)

        app.extensions[self.name] = self
        app.register_blueprint(self, **blueprint_options)

        resources: Iterable[Type[BaseResource]] = self.resources
        for resource_cls in resources:
            if resource_cls.url:
                urls = (
                    [resource_cls.url]
                    if isinstance(resource_cls.url, str)
                    else resource_cls.url
                )
                resource_urls = [url_join(base_url, url) for url in urls]
                api.add_resource(resource_cls, *resource_urls)
                print("> Resource:", resource_cls.__name__, "=>", resource_urls)
                if issubclass(resource_cls, MethodResource):
                    api_docs.register(resource_cls)

        self.after_install(app=app, jwt=jwt, api=api, api_docs=api_docs)

    def before_install(
        self,
        *,
        app: Flask,
        jwt: JWTManager,
        api: Api,
        api_docs: FlaskApiSpec,
        **kwargs,
    ) -> None:
        ...

    def after_install(
        self,
        *,
        app: Flask,
        jwt: JWTManager,
        api: Api,
        api_docs: FlaskApiSpec,
        **kwargs,
    ) -> None:
        ...

    def after_installed_all(
        self,
        app: Flask,
        installed_extensions: "Iterable[Extension]",
    ) -> None:
        ...
