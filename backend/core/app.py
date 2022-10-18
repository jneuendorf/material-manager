from flask import Flask
from flask_apispec import FlaskApiSpec
from flask_marshmallow import Marshmallow
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy

from core.commands import Commands
from core.config import flask_config
from core.helpers.orm import CrudModel

app: Flask = Flask(__name__)
app.config.update(flask_config)

# Flask Extensions
db: SQLAlchemy = SQLAlchemy(app, model_class=CrudModel)
api: Api = Api(app)
ma = Marshmallow(app)
api_docs = FlaskApiSpec(app)

# Convenience wrapper for running commands from Makefile.
commands = Commands(app, db)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"
