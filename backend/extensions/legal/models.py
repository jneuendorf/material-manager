from typing import Type

from core.extensions import db
from core.helpers.orm import CrudModel

Model: Type[CrudModel] = db.Model


class Imprint(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    club_name = db.Column(db.String(length=256), nullable=False)
    phone = db.Column(db.String(length=32), nullable=False)
    email = db.Column(db.String(length=128), nullable=False)
    board_members = db.relationship("BoardMember", backref="imprint")
    registration_number = db.Column(db.Integer, nullable=False)
    registry_court = db.Column(db.String(length=128), nullable=False)
    vat_number = db.Column(db.String(length=128), nullable=False)
    dispute_resolution_uri = db.Column(db.String(length=128), nullable=False)
    street = db.Column(db.String(length=100), nullable=False, default="")
    house_number = db.Column(
        db.String(length=8),
        nullable=False,
        default="",
    )  # allow 11A
    city = db.Column(db.String(length=80), nullable=False, default="")
    zip_code = db.Column(
        db.String(length=8),
        nullable=False,
        default="",
    )  # allow leading zeros


class BoardMember(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    member_first_name = db.Column(db.String(length=64), nullable=False)
    member_last_name = db.Column(db.String(length=64), nullable=False)
    position = db.Column(db.String(length=64), nullable=True)
    imprint_id = db.Column(db.ForeignKey(Imprint.id))


class PrivacyPolicy(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    company = db.Column(db.String(length=256), nullable=False)
    first_name = db.Column(db.String(length=64), nullable=False)
    last_name = db.Column(db.String(length=64), nullable=False)
    email = db.Column(db.String(length=128), nullable=False)
    phone = db.Column(db.String(length=32), nullable=False)
    street = db.Column(db.String(length=100), nullable=False, default="")
    house_number = db.Column(
        db.String(length=8),
        nullable=False,
        default="",
    )  # allow 11A
    city = db.Column(db.String(length=80), nullable=False, default="")
    zip_code = db.Column(
        db.String(length=8),
        nullable=False,
        default="",
    )  # allow leading zeros
