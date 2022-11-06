from flask import abort, send_from_directory

from core.config import flask_config
from core.helpers.resource import BaseResource, ModelListResource, ModelResource

from .models import Material as MaterialModel


class Material(ModelResource):
    url = "/{ext_name}/<int:material_id>"

    class Meta:
        model = MaterialModel
        fields = ("id", "first_name", "last_name")

    def get(self, material_id: int):
        material = MaterialModel.get(id=material_id)
        return self.serialize(material)


class Materials(ModelListResource):
    url = "/{ext_name}s"

    class Meta:
        model = MaterialModel
        fields = ("id", "last_name")

    def get(self):
        materials = MaterialModel.all()
        return self.serialize(materials)


class MaterialImages(BaseResource):
    url = "/material_images/<string:kind>/<int:material_id>/<int:image_id>"

    def get(self, kind, material_id, image_id):
        if kind != "sets" and kind != "single_material":
            return abort("Invalid kind", 400)

        return send_from_directory(
            f"{flask_config['FILESTORAGE_PATH']}/material/",
            f"{kind}/{material_id}/{image_id}.jpg",
        )
