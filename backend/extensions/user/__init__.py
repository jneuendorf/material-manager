from flask import Flask
from flask_apispec import FlaskApiSpec
from flask_jwt_extended import JWTManager
from flask_restful import Api

from core.helpers.extension import Extension
from core.signals import model_created

from . import models, resources
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
        resources.Login,
        resources.Profile,
    )

    def before_install(
        self,
        app: Flask,
        jwt: JWTManager,
        api: Api,
        api_docs: FlaskApiSpec,
    ):
        init_auth(jwt)


user = UserExtension("user", __name__)


def receiver(sender, data):
    print("user instance created:", sender, data)


model_created.connect(
    receiver,
    sender=models.User,
)
