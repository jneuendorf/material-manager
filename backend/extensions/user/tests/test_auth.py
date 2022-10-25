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
            membership_number="",
            phone="",
            street="",
            house_number="",
            city="",
            zip_code="",
        )
        user2 = User.create_from_password(
            email="two@localhost.com",
            password=password,
            first_name="",
            last_name="",
            membership_number="",
            phone="",
            street="",
            house_number="",
            city="",
            zip_code="",
        )
        assert user1.password_hash != user2.password_hash
        assert user1.verify_password(password)
        assert user2.verify_password(password)


def test_signup(client, app) -> None:
    success_response = client.post(
        "/signup",
        json={
            "email": "signup@localhost.com",
            "password": "test@R0oT!##",
            "first_name": "Max",
            "last_name": "Mustermann",
        },
    )
    assert success_response.status_code == 200
    # Check user was created
    with app.app_context():
        user = User.get_or_none(email="signup@localhost.com")
    assert user is not None
    assert not user.is_active

    # Signing up with the same data again should not be possible,
    # because the e-mail address is already taken.
    failure_response = client.post(
        "/signup",
        json={
            "email": "signup@localhost.com",
            "password": "test@R0oT!##",
            "first_name": "Max",
            "last_name": "Musterfrau?",
        },
    )
    assert failure_response.status_code == 403


def test_login(client, app):
    with app.app_context():
        user = User.create_from_password(
            email="login@localhost.com",
            password="test",
            first_name="",
            last_name="",
            membership_number="",
            phone="",
            street="",
            house_number="",
            city="",
            zip_code="",
        )
    response = client.post(
        "/login",
        json={
            "email": "login@localhost.com",
            "password": "test",
        },
    )
    assert response.status_code == 401

    with app.app_context():
        user.update(is_active=True)
    response = client.post(
        "/login",
        json={
            "email": "login@localhost.com",
            "password": "test",
        },
    )
    assert response.status_code == 200
    token = response.json["access_token"]
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
