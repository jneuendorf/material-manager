from app import create_app
from core.config import flask_config

app = create_app(flask_config)


@app.route("/")
def hello_world():
    return "Hello, World!"
