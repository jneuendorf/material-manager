from graphlib import TopologicalSorter

from flask import Flask
from flask_sqlalchemy import SQLAlchemy

from core import installed_extensions
from core.commands import Commands
from core.config import flask_config

app: Flask = Flask(__name__)
app.config.update(flask_config)

# Flask Extensions
db: SQLAlchemy = SQLAlchemy(app)


# Install extensions according to their interdependencies.
# Each extension's models are iteratively saved in the 'models' dictionary, e.g.
# { 'user': {'User', UserModel} }
models: dict[str, dict] = {}
dependency_graph: dict[str, list[str]] = {
    extension_cls.name: extension_cls.dependencies
    for extension_cls in installed_extensions.extension_classes
}
sorted_extension_names = list(TopologicalSorter(dependency_graph).static_order())
for extension_cls in sorted(
    installed_extensions.extension_classes,
    key=lambda ext_cls: sorted_extension_names.index(ext_cls.name),
):
    extension = extension_cls(app, db, models)
    models[extension.name] = extension.models

# Convenience wrapper for running commands from Makefile.
commands = Commands(db)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"
