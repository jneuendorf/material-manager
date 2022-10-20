import re
from abc import ABC
from collections.abc import Iterable
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
    models: M
    resources: R

    def __init__(
        self,
        name: str,
        import_name: str,
        models: M = None,
        resources: R = None,
        **kwargs,
    ):
        super().__init__(name, import_name, **kwargs)
        if models is not None:
            self.models = models
        if resources is not None:
            self.resources = resources

    def before_install(
        self,
        app: Flask,
        jwt: JWTManager,
        api: Api,
        api_docs: FlaskApiSpec,
    ) -> None:
        ...

    def install(
        self,
        app: Flask,
        jwt: JWTManager,
        api: Api,
        api_docs: FlaskApiSpec,
        base_url: str = "/",
        **blueprint_options: Any,
    ) -> None:
        self.before_install(app, jwt, api, api_docs)

        print("INSTALLING EXTENSIONS", self.name)
        app.register_blueprint(self, **blueprint_options)
        resource_cls: Type[BaseResource]
        for resource_cls in self.resources:
            resource_url = url_join(
                base_url, resource_cls.url.format(ext_name=self.name)
            )
            api.add_resource(resource_cls, resource_url)
            print("> Resource:", resource_cls.__name__, "=>", resource_url)
            if issubclass(resource_cls, MethodResource):
                api_docs.register(resource_cls)
