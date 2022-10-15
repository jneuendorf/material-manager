from flask import Flask
from flask_sqlalchemy import SQLAlchemy


class Commands:
    def __init__(self, app: Flask, db: SQLAlchemy):
        @app.cli.command("create-db")
        # @click.argument("name")
        def create_db():
            with app.app_context():
                db.create_all()
