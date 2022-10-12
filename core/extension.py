from abc import ABC
from collections.abc import Iterable
from typing import final

from blinker import Signal
from flask import Flask
from flask_sqlalchemy import SQLAlchemy


class Extension(ABC):
    dependencies: list[str] = []
    name: str
    db: SQLAlchemy
    models: dict

    @final
    def __init__(self, app: Flask, db: SQLAlchemy, models: dict):
        """Constructor is marked as final so that extending modules cannot accidentally
        set `self.app = app` since this is forbidden.
        See https://flask.palletsprojects.com/en/2.2.x/extensiondev/.
        """

        # For typing reasons (in app.py), we cannot declare name as abstract property
        if not self.name:
            raise TypeError("extension has no name")

        self.db = db
        self.init_app(app)
        models = self.register_models(db, existing_models=models)
        # TODO: pass signals
        signals = self.subscribe_signals([])

        app.extensions[self.name] = {
            "models": models,
            "subscribed_signals": signals,
        }

    def init_app(self, app: Flask) -> None:
        """Returns the app instance."""
        ...

    def register_models(self, db: SQLAlchemy, existing_models: dict) -> dict:
        """Define your models here! They are then visible to the app."""
        return {}

    def subscribe_signals(self, signals: Iterable[Signal]) -> Iterable[Signal]:
        """Subscribe to signals if you need to.
        You can identify a signal by its 'name' attribute.
        """
        return []
