from typing import Type

from passlib.hash import argon2
from sqlalchemy import Table

from core.db import db
from core.helpers.orm import CrudModel

Model: Type[CrudModel] = db.Model


class User(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(length=128), nullable=False, unique=True)
    password_hash = db.Column(db.String(length=512), nullable=False)
    first_name = db.Column(db.String(length=64), nullable=False)
    last_name = db.Column(db.String(length=64), nullable=False)
    membership_number = db.Column(db.String(length=16))
    phone = db.Column(db.String(length=32))
    street = db.Column(db.String(length=100))
    house_number = db.Column(db.String(length=8))  # allow 11A
    city = db.Column(db.String(length=80))  # allow '11A'
    zip = db.Column(db.String(length=8))  # allow leading zeros
    roles = db.relationship("Role", secondary="user_role_mapping", backref="users")

    @classmethod
    def create_from_password(
        cls,
        email: str,
        password: str,
        first_name: str,
        last_name: str,
        membership_number: str = "",
        *,
        roles: "list[Role]" = None,
    ):
        password_hash: str = argon2.hash(password)
        related = dict(roles=roles) if roles else None
        return cls.create(
            email=email,
            password_hash=password_hash,
            first_name=first_name,
            last_name=last_name,
            membership_number=membership_number,
            _related=related,
        )

    def verify_password(self, password: str) -> bool:
        return argon2.verify(password, self.password_hash)

    @property
    def permissions(self) -> "list[Permission]":
        # TODO: use joins
        #  https://docs.sqlalchemy.org/en/14/tutorial/orm_related_objects.html#using-relationships-in-queries
        print(self.roles)
        return [right for role in self.roles for right in role.permissions]


class Role(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String)
    description = db.Column(db.String)
    permissions = db.relationship(
        "Permission", secondary="role_permission_mapping", backref="roles"
    )


class Permission(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String)
    description = db.Column(db.String)


UserRoleMapping: Table = db.Table(
    "user_role_mapping",
    db.Column("user_id", db.ForeignKey(User.id), primary_key=True),
    db.Column("role_id", db.ForeignKey(Role.id), primary_key=True),
)

RolePermissionMapping: Table = db.Table(
    "role_permission_mapping",
    db.Column("role_id", db.ForeignKey(Role.id), primary_key=True),
    db.Column("permission_id", db.ForeignKey(Permission.id), primary_key=True),
)
