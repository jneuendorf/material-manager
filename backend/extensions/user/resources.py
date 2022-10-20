from flask import abort
from flask_apispec import use_kwargs
from flask_jwt_extended import create_access_token, current_user
from marshmallow import fields
from sqlalchemy.exc import IntegrityError

from core.helpers.resource import BaseResource, ModelListResource, ModelResource

from .decorators import permissions_required, session_required
from .models import User as UserModel


class User(ModelResource):
    url = "/user/<int:user_id>"

    class Meta:
        model = UserModel
        fields = ("id", "first_name", "last_name")

    def get(self, user_id: int) -> dict:
        user = UserModel.get(id=user_id)
        return self.schema.dump(user)


class Signup(BaseResource):
    url = "/signup"

    @use_kwargs(
        {
            "email": fields.Str(),
            "password": fields.Str(),
            "first_name": fields.Str(),
            "last_name": fields.Str(),
            "membership_number": fields.Str(),
        }
    )
    def post(
        self,
        email: str = None,
        password: str = None,
        first_name: str = None,
        last_name: str = None,
        membership_number: str = "",
    ):
        if not (email and password and first_name and last_name):
            return abort(400, "Missing some signup data")

        try:
            # TODO: default role(s)
            user = UserModel.create_from_password(
                email,
                password,
                first_name,
                last_name,
                membership_number,
            )
            return dict(access_token=create_access_token(identity=user))
        except (ValueError, IntegrityError):
            return abort(403, "E-mail address already taken")


class Login(BaseResource):
    url = "/login"

    @use_kwargs({"email": fields.Str(), "password": fields.Str()})
    def post(self, email: str = None, password: str = None):
        """
        curl -X POST 'http://localhost:5000/login' -H 'Content-Type: application/json' -d '{"email":"root@localhost.com","password":"asdf"}'
        """  # noqa
        user = UserModel.get_or_none(email=email)
        if not user or not user.verify_password(password):
            return abort(401, "Wrong email or password")
            # return jsonify("Wrong email or password"), 401

        return dict(access_token=create_access_token(identity=user))


class Profile(ModelResource):
    url = "/user/profile"

    class Meta:
        model = UserModel
        fields = ("id", "first_name", "last_name", "email", "membership_number")

    @session_required
    def get(self) -> dict:
        return self.schema.dump(current_user)


class Users(ModelListResource):
    url = "/users"

    class Meta:
        model = UserModel
        fields = ("id", "last_name")

    @permissions_required("user:read")
    def get(self):
        """
        curl -X GET 'http://localhost:5000/users' -H 'Authorization: Bearer <JWT>'
        """
        users = UserModel.all()
        return self.serialize(users)

    @use_kwargs(
        {
            "email": fields.Str(),
            "first_name": fields.Str(),
            "last_name": fields.Str(),
            "membership_number": fields.Str(),
        }
    )
    @permissions_required("user:write")
    def put(self, **kwargs) -> dict:
        """Test with
        curl -X PUT 'http://localhost:5000/users' -H 'Content-Type: application/json' -d '{"first_name":"max","last_name":"mustermann","membership_number":"123"}'
        curl -X PUT 'http://localhost:5000/users' -F 'first_name=max' -F 'last_name=mustermann' -F 'membership_number=123'
        """  # noqa
        user = UserModel.create(**kwargs)
        return self.schema.dump(user, many=False)
