from flask import current_app
from flask_sqlalchemy import SQLAlchemy


class Commands:
    db: SQLAlchemy

    def __init__(self, db: SQLAlchemy):
        self.db = db

    def create_db(self):
        with current_app.app_context():
            self.db.create_all()
