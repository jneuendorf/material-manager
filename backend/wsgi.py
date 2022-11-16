from app import create_app
from core.config import flask_config
from core.extensions import db, mail

app = create_app(flask_config, db, mail, drop_db=False)

if __name__ == "__main__":
    app.run()
