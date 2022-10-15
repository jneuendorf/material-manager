from collections.abc import Collection
from typing import Type, cast

from flask import Flask
from flask_apispec import FlaskApiSpec
from flask_marshmallow import Marshmallow
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy

from core.commands import Commands
from core.config import flask_config
from core.helpers import Extension
from core.installed_extensions import extensions
from core.utils import install_extensions

app: Flask = Flask(__name__)
app.config.update(flask_config)

# Flask Extensions
db: SQLAlchemy = SQLAlchemy(app)
api: Api = Api(app)
ma = Marshmallow(app)
api_docs = FlaskApiSpec(app)

install_extensions(
    cast(Collection[Type[Extension]], extensions),
    app,
    db,
    api,
    ma,
    api_docs,
)

# Convenience wrapper for running commands from Makefile.
commands = Commands(app, db)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"
