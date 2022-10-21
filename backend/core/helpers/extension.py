import re
from abc import ABC
from collections.abc import Iterable, Mapping
from typing import Any, Generic, Type, TypeVar, Union

from flask import Blueprint, Flask
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


class Extension(Blueprint, ABC, Generic[M, R]):
    models: M = ()  # type: ignore
    resources: R = ()  # type: ignore
    permissions: Iterable[Mapping[str, str]] = ()

    def __init__(
        self,
        name: str,
        import_name: str,
        models: M = None,
        resources: R = None,
        permissions: Iterable[Mapping[str, str]] = None,
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
        app.register_blueprint(self, **blueprint_options)

        resources: Iterable[Type[BaseResource]] = self.resources
        for resource_cls in resources:
            resource_url = url_join(
                base_url, resource_cls.url.format(ext_name=self.name)
            )
            api.add_resource(resource_cls, resource_url)
            print("> Resource:", resource_cls.__name__, "=>", resource_url)
            if issubclass(resource_cls, MethodResource):
                api_docs.register(resource_cls)

    def after_installed_all(
        self,
        app: Flask,
        installed_extensions: "Iterable[Extension]",
    ) -> None:
        ...
