from typing import Optional

from flask import abort, redirect
from flask_apispec import use_kwargs
from flask_jwt_extended import (
    create_access_token,
    create_refresh_token,
    current_user,
    get_jwt_identity,
    jwt_required,
)
from flask_mail import Message
from sqlalchemy.exc import IntegrityError
from webargs import fields, validate

from core.config import flask_config
from core.extensions import mail
from core.helpers.resource import BaseResource, ModelListResource, ModelResource
from core.helpers.schema import BaseSchema

from .auth import password_policy
from .decorators import login_required, permissions_required
from .models import User as UserModel


class UserSchema(BaseSchema):
    class Meta:
        model = UserModel
        fields = ("id", "first_name", "last_name", "email", "membership_number")


class User(ModelResource):
    url = "/user/<int:user_id>"
    Schema = UserSchema

    def get(self, user_id: int) -> dict:
        user = UserModel.get(id=user_id)
        return self.schema.dump(user)


class Signup(BaseResource):
    url = "/signup"

    @use_kwargs(
        {
            "email": fields.Str(
                required=True,
                validate=validate.Email(),  # type: ignore
            ),
            "password": fields.Str(required=True),
            "first_name": fields.Str(required=True),
            "last_name": fields.Str(required=True),
            "membership_number": fields.Str(load_default=""),
            "phone": fields.Str(load_default=""),
            "street": fields.Str(load_default=""),
            "house_number": fields.Str(load_default=""),
            "city": fields.Str(load_default=""),
            "zip_code": fields.Str(load_default=""),
        }
    )
    def post(
        self,
        email: str,
        password: str,
        first_name: str,
        last_name: str,
        membership_number: str,
        phone: str,
        street: str,
        house_number: str,
        city: str,
        zip_code: str,
    ):
        failed_tests = password_policy.test(password)
        if failed_tests:
            abort(401, "Password is too weak")

        try:
            # TODO: default role(s)
            user = UserModel.create_from_password(
                email,
                password,
                first_name,
                last_name,
                membership_number,
                phone,
                street,
                house_number,
                city,
                zip_code,
            )
            verification_link = (
                f'{flask_config["CORE_PUBLIC_API_URL"]}'
                f"{SignupVerification.url}"
                f"?user_id={user.id}&token={user.token}"
            )
            mail.send(
                Message(
                    subject="Verify your account",
                    body=f"Click this link to verify your account: {verification_link}",
                    html=f'<p>Click <a href="{verification_link}">here</a> to verify your account</p>',  # noqa
                    recipients=[email],
                )
            )
            return {
                "message": "Signup successful. Verify your e-mail address to login.",
            }
        except (ValueError, IntegrityError):
            return abort(403, "E-mail address already taken")


class SignupVerification(BaseResource):
    url = "/signup/verify"

    @use_kwargs(
        {
            "user_id": fields.Int(required=True),
            "token": fields.Str(required=True),
        },
        location="query",
    )
    def get(self, user_id: int, token: str):
        user = UserModel.get_or_none(id=user_id, token=token)
        if user:
            user.update(
                token="",  # invalidate token
                is_active=True,
            )
            # TODO: How to not hard-code the login URL?
            # TODO: Get FE domain from request header 'Origin'
            return redirect(f'{flask_config["CORE_PUBLIC_FRONTEND_URL"]}/#/login')
        else:
            abort(401, "Verification failed")


class Login(BaseResource):
    url = "/login"

    @use_kwargs({"email": fields.Str(), "password": fields.Str()})
    def post(self, email: Optional[str] = None, password: Optional[str] = None):
        """
        curl -X POST 'http://localhost:5000/login' -H 'Content-Type: application/json' -d '{"email":"root@localhost.com","password":"asdf"}'
        """  # noqa
        user = UserModel.get_or_none(email=email, is_active=True)
        if not user or not user.verify_password(password):
            return abort(
                401,
                "Invalid credentials or your account has not been activated yet",
            )

        additional_claims = {
            "permissions": {
                permission.id: permission.name for permission in user.permissions
            },
        }

        return dict(
            access_token=create_access_token(
                identity=user,
                additional_claims=additional_claims,
            ),
            refresh_token=create_refresh_token(identity=user),
        )


class Refresh(BaseResource):
    url = "/refresh"

    @jwt_required(refresh=True)
    def get(self):
        """
        curl -X GET 'http://localhost:5000/refresh' -H 'Authorization: Bearer <JWT>'
        """
        identity = get_jwt_identity()
        user = UserModel.get_or_none(id=identity)

        if not user:
            return abort(
                401,
                "Account has not been found",
            )

        additional_claims = {
            "permissions": {
                permission.id: permission.name for permission in user.permissions
            },
        }

        return dict(
            access_token=create_access_token(
                identity=current_user,
                fresh=False,
                additional_claims=additional_claims,
            ),
        )


class Profile(ModelResource):
    url = "/user/profile"
    Schema = UserSchema

    @login_required
    def get(self) -> dict:
        return self.schema.dump(current_user)


class Users(ModelListResource):
    url = "/users"
    Schema = UserSchema

    @permissions_required("user:read")
    def get(self):
        """
        curl -X GET 'http://localhost:5000/users' -H 'Authorization: Bearer <JWT>'
        """
        users = UserModel.all()
        return self.serialize(users)

    # @use_kwargs(
    #     {
    #         "email": fields.Str(),
    #         "first_name": fields.Str(),
    #         "last_name": fields.Str(),
    #         "membership_number": fields.Str(),
    #     }
    # )
    # @permissions_required("user:write")
    # def put(self, **kwargs) -> dict:
    #     """Test with
    #     curl -X PUT 'http://localhost:5000/users' \
    #     -H 'Content-Type: application/json' \
    #     -d '{"first_name":"max","last_name":"mustermann","membership_number":"123"}'
    #     """  # noqa
    #     user = UserModel.create(**kwargs)
    #     return self.serialize_single(user)
