from abc import ABC, abstractmethod
from collections.abc import Iterable
from typing import final

from blinker import Signal
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import DeclarativeMeta


class Extension(ABC):
    db: SQLAlchemy
    models: dict

    @final
    def __init__(self, app: Flask, db: SQLAlchemy):
        """Constructor is marked as final so that extending modules cannot accidentally
        set `self.app = app` since this is forbidden.
        See https://flask.palletsprojects.com/en/2.2.x/extensiondev/.
        """
        self.db = db
        self.init_app(app)
        models = self.register_models(db)
        # TODO: pass signals
        signals = self.subscribe_signals([])

        app.extensions[self.name] = {
            "models": models,
            "subscribed_signals": signals,
        }

    @property
    @abstractmethod
    def name(self) -> str:
        ...

    def init_app(self, app: Flask) -> None:
        """Returns the app instance."""
        ...

    def register_models(self, db: SQLAlchemy) -> dict:
        """Define your models here! They are then visible to the app."""
        return {}

    def subscribe_signals(self, signals: Iterable[Signal]) -> Iterable[Signal]:
        """Subscribe to signals if you need to.
        You can identify a signal by its 'name' attribute.
        """
        return []
