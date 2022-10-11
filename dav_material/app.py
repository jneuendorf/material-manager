from flask import Flask

from dav_material.db import db

# create the app
app: Flask = Flask(__name__)
# configure the SQLite database, relative to the app instance folder
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///test.db"
# initialize the app with the extension
db.init_app(app)


def create_db() -> None:
    with app.app_context():
        db.create_all()


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"
