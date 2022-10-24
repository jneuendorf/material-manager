from extensions.user.models import User

from . import conftest  # noqa


def test_password_hashing(app):
    password = "test"
    with app.app_context():
        user1 = User.create_from_password(
            email="one@localhost.com",
            password=password,
            first_name="",
            last_name="",
        )
        user2 = User.create_from_password(
            email="two@localhost.com",
            password=password,
            first_name="",
            last_name="",
        )
        assert user1.password_hash != user2.password_hash
        assert user1.verify_password(password)
        assert user2.verify_password(password)


def test_signup(client, app) -> None:
    success_response = client.post(
        "/signup",
        json={
            "email": "signup@localhost.com",
            "password": "test",
            "first_name": "Max",
            "last_name": "Mustermann",
        },
    )
    assert success_response.status_code == 200
    # Check token
    token = success_response.json["access_token"]
    assert isinstance(token, str) and len(token) > 0
    # Check user was created
    with app.app_context():
        user = User.get_or_none(email="signup@localhost.com")
    assert user is not None

    # Signing up with the same data again should not be possible,
    # because the e-mail address is already taken.
    failure_response = client.post(
        "/signup",
        json={
            "email": "signup@localhost.com",
            "password": "test",
            "first_name": "Max",
            "last_name": "Musterfrau?",
        },
    )
    assert failure_response.status_code == 403


def test_login(client, app):
    with app.app_context():
        User.create_from_password(
            email="login@localhost.com",
            password="test",
            first_name="",
            last_name="",
        )
    success_response = client.post(
        "/login",
        json={
            "email": "login@localhost.com",
            "password": "test",
        },
    )
    assert success_response.status_code == 200
    token = success_response.json["access_token"]
    assert isinstance(token, str) and len(token) > 0

    # Check login with valid session
    success_response2 = client.post(
        "/login",
        json={
            "email": "login@localhost.com",
            "password": "test",
        },
    )
    assert success_response2.status_code == 200
    token2 = success_response2.json["access_token"]
    assert token2 != token
