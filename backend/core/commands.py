from collections.abc import Collection
from importlib import import_module

import click
from flask import Flask
from flask_sqlalchemy import SQLAlchemy


def init_cli_commands(app: Flask, db: SQLAlchemy):
    @app.cli.command("create-sample-data")
    @click.argument("extensions", nargs=-1)
    def create_sample_data(extensions: Collection[str]):
        with app.app_context():
            for extension in extensions:
                import_module(f"extensions.{extension}.sample_data")
