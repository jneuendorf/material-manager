from core.helpers.resource import ModelListResource, ModelResource

from .models import User as UserModel


class User(ModelResource):
    url = "/{ext_name}/<int:user_id>"

    class Meta:
        model = UserModel
        fields = ("id", "first_name", "last_name")

    def get(self, user_id: int) -> dict:
        user = UserModel.get(id=user_id)
        return self.schema.dump(user)


class Users(ModelListResource):
    url = "/{ext_name}s"

    class Meta:
        model = UserModel
        fields = ("id", "last_name")

    def get(self):
        users = UserModel.all()
        return self.serialize(users)
