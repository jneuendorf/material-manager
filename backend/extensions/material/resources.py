from core.helpers.resource import ModelListResource, ModelResource

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
