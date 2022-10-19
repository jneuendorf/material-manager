from flask import request

from core.helpers.resource import ModelListResource, ModelResource

from .decorators import rights_required
from .models import User as UserModel


class User(ModelResource):
    url = "/user/<int:user_id>"

    class Meta:
        model = UserModel
        fields = ("id", "first_name", "last_name")

    def get(self, user_id: int) -> dict:
        user = UserModel.get(id=user_id)
        return self.schema.dump(user)


class Users(ModelListResource):
    url = "/users"

    class Meta:
        model = UserModel
        fields = ("id", "last_name")

    @rights_required("user:read")
    def get(self):
        """
        curl -X GET 'http://localhost:5000/users' -H 'Authorization: Bearer <JWT>'
        """
        users = UserModel.all()
        return self.serialize(users)

    @rights_required("user:write")
    def put(self) -> dict:
        """Test with
        curl -X PUT 'http://localhost:5000/users' -H 'Content-Type: application/json' -d '{"first_name":"max","last_name":"mustermann","membership_number":"123"}'
        curl -X PUT 'http://localhost:5000/users' -F 'first_name=max' -F 'last_name=mustermann' -F 'membership_number=123'
        """  # noqa
        # TODO: decide on one convention
        data = request.json or request.form
        user = UserModel.create(**data)
        return self.schema.dump(user, many=False)
