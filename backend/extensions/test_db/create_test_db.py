from app import create_app
from core.config import flask_config
from core.db import db
from core.extensions import mail

from . import csv_import, generate_data

app = create_app(
    {
        **flask_config,
        **{
            "TESTING": True,
            "SQLALCHEMY_DATABASE_URI": "sqlite:///test_db.db",
        },
    },
    db,
    mail,
)

with app.app_context():
    db.drop_all()
    db.create_all()

    data_sheet = csv_import.import_data()
    generate_data.test_data(data_sheet)

    # result = db.session.query(EquipmentType).all()
