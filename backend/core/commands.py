from importlib import import_module

import click
from flask import Flask
from flask_sqlalchemy import SQLAlchemy


class Commands:
    def __init__(self, app: Flask, db: SQLAlchemy):
        @app.cli.command("create-db")
        def create_db():
            with app.app_context():
                db.create_all()

        @app.cli.command("create-test-data")
        @click.argument("extension")
        def create_test_data(extension: str):
            with app.app_context():
                import_module(f"extensions.{extension}.fixtures")
