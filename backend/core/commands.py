from importlib import import_module

import click
from flask import Flask
from flask_sqlalchemy import SQLAlchemy


def init_cli_commands(app: Flask, db: SQLAlchemy):
    @app.cli.command("create-test-data")
    def create_test_db():
        with app.app_context():
            import_module("extensions.material.sample_data")
            # TODO
            # import_module("extensions.rental.sample_data")

    @app.cli.command("create-sample-data")
    @click.argument("extension")
    def create_sample_data(extension: str):
        with app.app_context():
            import_module(f"extensions.{extension}.sample_data")
