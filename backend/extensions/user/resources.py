from flask import abort, request
from flask_jwt_extended import create_access_token, current_user
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

    def post(self):
        email = request.json.get("email", None)
        password = request.json.get("password", None)
        first_name = request.json.get("first_name", None)
        last_name = request.json.get("last_name", None)
        if not email or not password:
            return abort(400, "Missing some signup data")

        try:
            # TODO: default role(s)
            user = UserModel.from_password(
                email,
                password,
                first_name,
                last_name,
                membership_number=request.json.get("membership_number", ""),
            )
            return dict(access_token=create_access_token(identity=user))
        except (ValueError, IntegrityError):
            return abort(403, "E-mail address already taken")


class Login(BaseResource):
    url = "/login"

    def post(self):
        """
        curl -X POST 'http://localhost:5000/login' -H 'Content-Type: application/json' -d '{"email":"root@localhost.com","password":"asdf"}'
        """  # noqa
        email = request.json.get("email", None)
        password = request.json.get("password", None)
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

    @permissions_required("user:write")
    def put(self) -> dict:
        """Test with
        curl -X PUT 'http://localhost:5000/users' -H 'Content-Type: application/json' -d '{"first_name":"max","last_name":"mustermann","membership_number":"123"}'
        curl -X PUT 'http://localhost:5000/users' -F 'first_name=max' -F 'last_name=mustermann' -F 'membership_number=123'
        """  # noqa
        # TODO: decide on one convention
        data = request.json or request.form
        user = UserModel.create(**data)
        return self.schema.dump(user, many=False)
