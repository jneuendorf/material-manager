from flask import Flask, jsonify, request
from flask_apispec import FlaskApiSpec
from flask_jwt_extended import (
    JWTManager,
    create_access_token,
    current_user,
    jwt_required,
)
from flask_restful import Api

from core.helpers.extension import Extension
from core.signals import model_created

from . import models, resources


class UserExtension(Extension):
    models = (
        models.User,
        models.Role,
        models.Right,
        models.RoleRightMapping,
        models.UserRoleMapping,
    )
    resources = (
        resources.User,
        resources.Users,
    )

    def before_install(
        self,
        app: Flask,
        jwt: JWTManager,
        api: Api,
        api_docs: FlaskApiSpec,
    ):
        @jwt.user_identity_loader
        def user_identity_lookup(user: models.User):
            return user.id

        @jwt.user_lookup_loader
        def user_lookup_callback(_jwt_header, jwt_data):
            identity = jwt_data["sub"]
            return models.User.get_or_none(id=identity)

        @app.route("/login", methods=["POST"])
        def login():
            """
            curl -X POST 'http://localhost:5000/login' -H 'Content-Type: application/json' -d '{"email":"root@localhost.com","password":"asdf"}'
            """  # noqa
            email = request.json.get("email", None)
            password = request.json.get("password", None)
            user = models.User.get_or_none(email=email)
            if not user or not user.verify_password(password):
                return jsonify("Wrong email or password"), 401

            access_token = create_access_token(identity=user)
            return jsonify(access_token=access_token)

        @app.route("/whoami", methods=["GET"])
        @jwt_required()
        def protected():
            return jsonify(
                id=current_user.id,
                full_name=current_user.first_name,
            )


user = UserExtension("user", __name__)


def receiver(sender, data):
    print("user instance created:", sender, data)


model_created.connect(
    receiver,
    sender=models.User,
)
