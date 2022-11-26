from flask_apispec import use_kwargs

from core.helpers.resource import ModelListResource, ModelResource
from extensions.material import models
from extensions.material.resources.schemas import MaterialTypeSchema


class MaterialType(ModelResource):
    url = [
        "/material_type",
        "/material_type/<int:type_id>",
    ]
    Schema = MaterialTypeSchema

    def get(self, type_id: int):
        """Test with
        curl -X GET "http://localhost:5000/material_type/1"
        """
        material_type = models.MaterialType.get(id=type_id)
        return self.serialize(material_type)

    @use_kwargs(
        MaterialTypeSchema.to_dict(
            name=dict(required=True),
            description=dict(required=True),
        )
    )
    def post(self, **kwargs) -> dict:
        """Test with
        curl -X POST "http://localhost:5000/material_type" \
        -H 'Content-Type: application/json' \
        -d '{"name":"Seile", "description":"Seil zum Klettern"}'
        """
        material_type = models.MaterialType.create(**kwargs)
        return self.serialize(material_type)


class MaterialTypes(ModelListResource):
    url = "/material_types"
    Schema = MaterialTypeSchema

    def get(self):
        material_types = models.MaterialType.all()
        return self.serialize(material_types)
