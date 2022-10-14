from dataclasses import dataclass
from typing import NamedTuple, Type

from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Table
from sqlalchemy.orm import DeclarativeMeta

from backend.core.helpers import Extension, ModelListResource, ModelResource

from .resources import define_resources


@dataclass
class UserModels:
    User: DeclarativeMeta
    Role: DeclarativeMeta
    Right: DeclarativeMeta
    RoleRightMapping: Table
    UserRoleMapping: Table


class UserResources(NamedTuple):
    UserResource: Type[ModelResource]
    UserListResource: Type[ModelListResource]


class UserExtension(Extension[UserModels, UserResources]):
    name = "user"

    def register_models(self, db: SQLAlchemy):
        Model: DeclarativeMeta = db.Model

        class User(Model):
            id = db.Column(db.Integer, primary_key=True)
            firs_name = db.Column(db.String)
            last_name = db.Column(db.String)
            membership_number = db.Column(db.String)

        class Role(Model):
            id = db.Column(db.Integer, primary_key=True)
            name = db.Column(db.String)
            description = db.Column(db.String)

        class Right(Model):
            id = db.Column(db.Integer, primary_key=True)
            name = db.Column(db.String)
            description = db.Column(db.String)

        RoleRightMapping = db.Table(
            "role_right_mapping",
            db.Column("role_id", db.ForeignKey(Role.id), primary_key=True),
            db.Column("right_id", db.ForeignKey(Right.id), primary_key=True),
        )
        UserRoleMapping = db.Table(
            "user_role_mapping",
            db.Column("user_id", db.ForeignKey(User.id), primary_key=True),
            db.Column("role_id", db.ForeignKey(Role.id), primary_key=True),
        )

        return UserModels(
            **{
                "User": User,
                "Role": Role,
                "Right": Right,
                "RoleRightMapping": RoleRightMapping,
                "UserRoleMapping": UserRoleMapping,
            }
        )

    def get_resources(self, db: SQLAlchemy):
        UserResource, UserListResource = define_resources(db, self.models.User)
        return UserResources(
            UserResource=UserResource,
            UserListResource=UserListResource,
        )
