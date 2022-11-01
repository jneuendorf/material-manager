from collections.abc import Iterable
from typing import Any

from flask import Flask
from flask_apispec import FlaskApiSpec
from flask_jwt_extended import JWTManager
from flask_restful import Api

from core.helpers.extension import Extension
from core.signals import model_created

from . import models, permissions, resources
from .auth import init_auth


class UserExtension(Extension):
    models = (
        models.User,
        models.Role,
        models.Permission,
    )
    resources = (
        resources.User,
        resources.Users,
        resources.Signup,
        resources.SignupVerification,
        resources.Login,
        resources.Refresh,
        resources.Profile,
    )
    permissions = (
        permissions.superuser,
        permissions.user_read,
        permissions.user_write,
    )

    def before_install(
        self,
        *,
        app: Flask,
        jwt: JWTManager,
        api: Api,
        api_docs: FlaskApiSpec,
        **kwargs,
    ):
        init_auth(jwt)

    def after_installed_all(
        self,
        app: Flask,
        installed_extensions: "Iterable[Extension]",
    ) -> None:
        """Ensures permission instances in the database
        (from permission-data dictionaries).
        """
        with app.app_context():
            for extension in installed_extensions:
                for permission_kwargs in extension.permissions:
                    print(extension.name, "->", permission_kwargs["name"])
                    models.Permission.get_or_create(**permission_kwargs)


user = UserExtension("user", __name__)


def receiver(sender, data):
    print("user instance created:", sender, data)


model_created.connect(
    receiver,
    sender=models.User,
)
