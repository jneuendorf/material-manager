from abc import ABC
from collections.abc import Iterable
from typing import Generic, Type, TypeVar, final

from blinker import Signal
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

from .resource import ModelResource

T_co = TypeVar("T_co", covariant=True)
M = TypeVar("M")
R = TypeVar("R", bound=Iterable[Type[ModelResource]])


class Extension(ABC, Generic[M, R]):
    name: str
    """The extension's name.
    The extension can be accessed using `app.extensions[name]`.
    """

    models: M
    resources: R
    signals: Iterable[Signal]

    @final
    def __init__(self, app: Flask, db: SQLAlchemy):
        """Constructor is marked as final so that extending modules cannot accidentally
        set `self.app = app` since this is forbidden.
        See https://flask.palletsprojects.com/en/2.2.x/extensiondev/.
        """

        # For typing reasons (in app.py), we cannot declare name as abstract property
        if not self.name:
            raise TypeError("extension has no name")

        self.init_app(app)
        self.models = self.register_models(db)
        self.resources = self.get_resources(db)
        # TODO: pass actual signals
        self.signals = self.subscribe_signals([])

        app.extensions[self.name] = self

    def init_app(self, app: Flask) -> None:
        """Returns the app instance."""
        ...

    def register_models(self, db: SQLAlchemy) -> M:
        """Define your models here! They are then visible to the app."""
        ...

    def get_resources(self, db: SQLAlchemy) -> R:
        """Define your model resources here. See backend.core.helpers.ModelResource"""
        ...

    def subscribe_signals(self, signals: Iterable[Signal]) -> Iterable[Signal]:
        """Subscribe to signals if you need to.
        You can identify a signal by its 'name' attribute.
        """
        return []
