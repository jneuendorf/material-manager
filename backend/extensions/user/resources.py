from flask_marshmallow.sqla import SQLAlchemySchema
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import DeclarativeMeta

from backend.core.helpers import ModelListResource, ModelResource, with_db


def define_resources(db: SQLAlchemy, UserModel: DeclarativeMeta):
    @with_db(db)
    class UserResource(ModelResource):
        urls = ("{ext_name}/<int:user_id>",)

        class Schema(SQLAlchemySchema):
            class Meta:
                model = UserModel
                fields = ("id", "first_name", "last_name")

        def get(self, user_id: int) -> dict:
            user = self.orm.get(id=user_id)
            return self.schema.dump(user)

    @with_db(db)
    class UserListResource(ModelListResource):
        urls = ("/users",)

        class Schema(SQLAlchemySchema):
            class Meta:
                model = UserModel
                fields = ("id", "last_name")

        def get(self) -> list[dict]:
            users = self.orm.all()
            return self.schema.dump(users)

    return (
        UserResource,
        UserListResource,
    )
