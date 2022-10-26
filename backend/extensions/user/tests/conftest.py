import pytest

from app import create_app
from core.config import flask_config
from core.extensions import db, mail


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
        mail,
        drop_db=True,
    )

    # other setup can go here

    yield app

    # clean up / reset resources here


@pytest.fixture()
def client(app):
    return app.test_client()


@pytest.fixture()
def runner(app):
    return app.test_cli_runner()
