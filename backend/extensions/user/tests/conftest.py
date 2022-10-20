import pytest

from app import create_app
from core.config import flask_config
from core.db import db


@pytest.fixture()
def app():
    app = create_app(
        {
            **flask_config,
            **{
                "TESTING": True,
                "SQLALCHEMY_DATABASE_URI": "sqlite:///test.db",
            },
        },
        db,
    )

    # other setup can go here
    with app.app_context():
        db.drop_all()
        db.create_all()

    yield app

    # clean up / reset resources here
    with app.app_context():
        db.drop_all()


@pytest.fixture()
def client(app):
    return app.test_client()


@pytest.fixture()
def runner(app):
    return app.test_cli_runner()
