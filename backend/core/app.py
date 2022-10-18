from collections.abc import Iterable
from importlib import import_module
from typing import cast

from flask import Flask
from flask_apispec import FlaskApiSpec
from flask_marshmallow import Marshmallow
from flask_restful import Api

from core.commands import Commands
from core.config import flask_config
from core.db import db
from core.helpers.extension import Extension
from core.utils import install_extension

app: Flask = Flask(__name__)
app.config.update(flask_config)

# Flask Extensions
db.init_app(app)
api: Api = Api(app)
ma = Marshmallow(app)
api_docs = FlaskApiSpec(app)

# Convenience wrapper for running commands from Makefile.
commands = Commands(app, db)

installed_extensions: Iterable[str] = flask_config.get("INSTALLED_EXTENSIONS", [])
for extension_name in installed_extensions:
    # Simulate e.g. `from extensions.material import material`
    extension_module = import_module(f"extensions.{extension_name}")
    extension = cast(
        Extension,
        getattr(extension_module, extension_name),
    )
    install_extension(extension, app, api, api_docs)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"
