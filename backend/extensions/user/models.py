from typing import Type

from sqlalchemy import Table

from core.db import db
from core.helpers.orm import CrudModel

Model: Type[CrudModel] = db.Model


class User(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    firs_name = db.Column(db.String)
    last_name = db.Column(db.String)
    membership_number = db.Column(db.String)


class Role(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String)
    description = db.Column(db.String)


class Right(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String)
    description = db.Column(db.String)


RoleRightMapping: Table = db.Table(
    "role_right_mapping",
    db.Column("role_id", db.ForeignKey(Role.id), primary_key=True),
    db.Column("right_id", db.ForeignKey(Right.id), primary_key=True),
)
UserRoleMapping: Table = db.Table(
    "user_role_mapping",
    db.Column("user_id", db.ForeignKey(User.id), primary_key=True),
    db.Column("role_id", db.ForeignKey(Role.id), primary_key=True),
)
