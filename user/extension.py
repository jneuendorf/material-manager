from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import DeclarativeMeta

from core.extension import Extension


class UserExtension(Extension):
    name = "user"

    def register_models(self, db: SQLAlchemy, existing_models: dict = None) -> dict:
        Model: DeclarativeMeta = db.Model

        class User(Model):
            id = db.Column(db.Integer, primary_key=True)
            firs_name = db.Column(db.String)
            last_name = db.Column(db.String)
            membership_number = db.Column(db.Integer)

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

        return {
            "User": User,
            "Role": Role,
            "Right": Right,
            "RoleRightMapping": RoleRightMapping,
            "UserRoleMapping": UserRoleMapping,
        }
