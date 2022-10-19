from typing import Type

from passlib.hash import argon2
from sqlalchemy import Table

from core.db import db
from core.helpers.orm import CrudModel

Model: Type[CrudModel] = db.Model


class User(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(length=128), unique=True)
    password_hash = db.Column(db.String(length=512))
    first_name = db.Column(db.String(length=64))
    last_name = db.Column(db.String(length=64))
    membership_number = db.Column(db.String(length=16))
    roles = db.relationship("Role", secondary="user_role_mapping", backref="users")

    @classmethod
    def register(
        cls,
        email: str,
        password: str,
        first_name: str,
        last_name: str,
        membership_number: str,
    ):
        password_hash: str = argon2.hash(password)
        return cls.create(
            email=email,
            password_hash=password_hash,
            first_name=first_name,
            last_name=last_name,
            membership_number=membership_number,
        )

    def verify_password(self, password: str) -> bool:
        return argon2.verify(password, self.password_hash)

    @property
    def rights(self) -> "list[Right]":
        # TODO: use joins
        #  https://docs.sqlalchemy.org/en/14/tutorial/orm_related_objects.html#using-relationships-in-queries
        print(self.roles)
        return [right for role in self.roles for right in role.rights]


class Role(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String)
    description = db.Column(db.String)
    rights = db.relationship("Right", secondary="role_right_mapping", backref="roles")


class Right(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String)
    description = db.Column(db.String)


UserRoleMapping: Table = db.Table(
    "user_role_mapping",
    db.Column("user_id", db.ForeignKey(User.id), primary_key=True),
    db.Column("role_id", db.ForeignKey(Role.id), primary_key=True),
)

RoleRightMapping: Table = db.Table(
    "role_right_mapping",
    db.Column("role_id", db.ForeignKey(Role.id), primary_key=True),
    db.Column("right_id", db.ForeignKey(Right.id), primary_key=True),
)
