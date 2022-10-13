from abc import ABC
from collections.abc import Iterable
from dataclasses import dataclass
from typing import Generic, Type, TypeVar, final

from blinker import Signal
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_sqlalchemy.model import Model
from sqlalchemy import Column, Integer

M = TypeVar("M")


class ModelWithId(Model):
    id = Column(Integer, primary_key=True)


ModelWithIdType = Type[ModelWithId]


@dataclass
class Data(Generic[M]):
    models: M
    signals: Iterable[Signal]


class Extension(ABC, Generic[M]):
    name: str
    db: SQLAlchemy
    models: M

    @final
    def __init__(self, app: Flask, db: SQLAlchemy):
        """Constructor is marked as final so that extending modules cannot accidentally
        set `self.app = app` since this is forbidden.
        See https://flask.palletsprojects.com/en/2.2.x/extensiondev/.
        """

        # For typing reasons (in app.py), we cannot declare name as abstract property
        if not self.name:
            raise TypeError("extension has no name")

        self.db = db
        self.init_app(app)
        models = self.register_models(app, db)
        # TODO: pass signals
        signals = self.subscribe_signals([])

        data: Data[M] = Data(models, signals)
        app.extensions[self.name] = data

    def init_app(self, app: Flask) -> None:
        """Returns the app instance."""
        ...

    def register_models(self, app: Flask, db: SQLAlchemy) -> M:
        """Define your models here! They are then visible to the app.
        DO NOT SAVE THE APP ON THE EXTENSION!
        """
        ...

    def subscribe_signals(self, signals: Iterable[Signal]) -> Iterable[Signal]:
        """Subscribe to signals if you need to.
        You can identify a signal by its 'name' attribute.
        """
        return []
