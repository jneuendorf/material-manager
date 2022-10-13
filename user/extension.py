from typing import TypedDict

from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Table

from core.extension import Extension, ModelWithId, ModelWithIdType


class UserModels(TypedDict):
    User: ModelWithIdType
    Role: ModelWithIdType
    Right: ModelWithIdType
    RoleRightMapping: Table
    UserRoleMapping: Table


class UserExtension(Extension[UserModels]):
    name = "user"
    models: UserModels

    def register_models(self, db: SQLAlchemy) -> UserModels:
        class User(ModelWithId):
            firs_name = db.Column(db.String)
            last_name = db.Column(db.String)
            membership_number = db.Column(db.String)

        class Role(ModelWithId):
            name = db.Column(db.String)
            description = db.Column(db.String)

        class Right(ModelWithId):
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

        return {
            "User": User,
            "Role": Role,
            "Right": Right,
            "RoleRightMapping": RoleRightMapping,
            "UserRoleMapping": UserRoleMapping,
        }
