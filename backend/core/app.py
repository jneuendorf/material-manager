from app import create_app
from core.config import flask_config
from core.db import db

app = create_app(flask_config, db)


@app.route("/")
def hello_world():
    return "Hello, World!"
