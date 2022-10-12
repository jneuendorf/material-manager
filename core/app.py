from flask import Flask
from flask_sqlalchemy import SQLAlchemy

from core import installed_extensions
from core.commands import Commands
from core.config import flask_config

app: Flask = Flask(__name__)
app.config.update(flask_config)

# Flask Extensions
db: SQLAlchemy = SQLAlchemy(app)


# Install extensions
for extension_cls in installed_extensions.extension_classes:
    extension = extension_cls(app, db)

# Convenience wrapper for running commands from Makefile.
commands = Commands(db)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"
