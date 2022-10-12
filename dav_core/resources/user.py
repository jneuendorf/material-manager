from typing import Any

from flask_restful import Resource


# TODO: Dummy model
class User:
    query: Any


class UserSchema(ma.Schema):
    class Meta:
        fields = ("id", "first_name", "last_name")
        model = User


user_schema = UserSchema()
users_schema = UserSchema(many=True)


class UserResource(Resource):
    def get(self):
        posts = User.query.all()
        return users_schema.dump(posts)


# api.add_resource(PostListResource, '/posts')
