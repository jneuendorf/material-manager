from flask import Flask
from flask_marshmallow import Marshmallow
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy

from backend.core.commands import Commands
from backend.core.config import flask_config
from backend.core.installed_extensions import extensions
from backend.core.utils import install_extensions

app: Flask = Flask(__name__)
app.config.update(flask_config)

# Flask Extensions
db: SQLAlchemy = SQLAlchemy(app)
api: Api = Api(app)
ma = Marshmallow(app)

install_extensions(extensions, app, db, api)

# Convenience wrapper for running commands from Makefile.
commands = Commands(app, db)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"
