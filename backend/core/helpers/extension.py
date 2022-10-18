from abc import ABC
from collections.abc import Iterable
from typing import Generic, Type, TypeVar, Union

from flask import Blueprint
from sqlalchemy import Table

from core.app import api, api_docs, app

from ..utils import install_extension
from .orm import CrudModel
from .resource import ModelResource

M = TypeVar("M", bound=Iterable[Union[Type[CrudModel], Table]])
R = TypeVar("R", bound=Iterable[Type[ModelResource]])


class Extension(Blueprint, ABC, Generic[M, R]):
    models: M
    resources: R

    def __init__(self, name: str, import_name: str, models: M, resources: R, **kwargs):
        super().__init__(name, import_name, **kwargs)
        self.models = models
        self.resources = resources
        self.install()

    def install(self) -> None:
        install_extension(self, app, api, api_docs)
