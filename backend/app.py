from collections.abc import Iterable
from importlib import import_module
from typing import cast

from flask import Flask, abort
from flask_apispec import FlaskApiSpec
from flask_jwt_extended import JWTManager
from flask_mail import Mail
from flask_marshmallow import Marshmallow
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy
from webargs.flaskparser import parser

from core.commands import init_cli_commands
from core.helpers.extension import Extension


@parser.error_handler
def handle_request_parsing_error(err, req, schema, *, error_status_code, error_headers):
    """This error handler is necessary for usage with Flask-RESTful.
    webargs error handler that uses Flask-RESTful's abort function to return
    a JSON error response to the client.
    See https://github.com/marshmallow-code/webargs/issues/290#issuecomment-422231992
    """
    abort(error_status_code, errors=err.messages)


def create_app(config, db: SQLAlchemy, mail: Mail, drop_db=False):
    print("CREATING NEW APP!")
    app: Flask = Flask(__name__)
    app.config.update(config)

    # Flask Extensions
    db.init_app(app)
    jwt = JWTManager(app)
    api: Api = Api(app)
    Marshmallow(app)
    api_docs = FlaskApiSpec(app)
    mail.init_app(app)

    init_cli_commands(app, db)

    extensions_to_install: Iterable[str] = config.get("CORE_INSTALLED_EXTENSIONS", [])
    installed_extensions: list[Extension] = []
    for extension_name in extensions_to_install:
        # Simulate e.g. `from extensions.material import material`
        extension_module = import_module(f"extensions.{extension_name}")
        extension = cast(
            Extension,
            getattr(extension_module, extension_name),
        )
        print("INSTALLING EXTENSION:", extension.name)
        extension.install(app, jwt, api, api_docs)
        installed_extensions.append(extension)

    with app.app_context():
        if drop_db:
            print("DROPPING ALL DATABASE TABLES")
            db.drop_all()
        print("CREATING NON-EXISTING DATABASE TABLES")
        db.create_all()

    for extension in installed_extensions:
        print("AFTER INSTALLED ALL:", extension.name)
        extension.after_installed_all(app, installed_extensions)

    return app
