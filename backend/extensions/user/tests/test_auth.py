import pytest

from app import create_app
from core.config import flask_config
from core.db import db
from extensions.user.models import User


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


def test_signup(client, app) -> None:
    success_response = client.post(
        "/signup",
        json={
            "email": "test@localhost.com",
            "password": "test",
            "first_name": "Max",
            "last_name": "Mustermann",
        },
    )
    assert success_response.status_code == 200
    token = success_response.json["access_token"]
    assert isinstance(token, str) and len(token) > 0
    with app.app_context():
        user = User.get_or_none(
            email="test@localhost.com",
            first_name="Max",
            last_name="Mustermann",
        )
    assert user is not None

    # Signing up with the same data again should not be possible,
    # because the e-mail address is already taken.
    failure_response = client.post(
        "/signup",
        json={
            "email": "test@localhost.com",
            "password": "test",
            "first_name": "Max",
            "last_name": "Mustermann",
        },
    )
    assert failure_response.status_code == 403
