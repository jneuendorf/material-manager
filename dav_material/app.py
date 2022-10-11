from flask import Flask
from models import db

# create the app
app = Flask(__name__)
# configure the SQLite database, relative to the app instance folder
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///test.db"
# initialize the app with the extension
db.init_app(app)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"


if __name__ == "__main__":
    with app.app_context():
        db.create_all()
