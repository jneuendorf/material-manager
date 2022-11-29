from typing import cast

from sqlalchemy.sql import Select

from core.helpers.resource import ModelListResource
from extensions.material.models import MaterialType, PropertyType
from extensions.material.resources.schemas import PropertyTypeSchema


class PropertyTypes(ModelListResource):
    url = [
        "/property_types/<string:material_type_name>",
    ]
    Schema = PropertyTypeSchema

    def get(self, material_type_name: str):
        query = MaterialType.get_query()
        statement = cast(
            Select,
            query.select().where(MaterialType.name.ilike(f"%{material_type_name}%")),
        )
        result = query.execute(statement)
        material_types: list[MaterialType] = result.scalars().all()
        # Ensure distinct property types because found material types could have
        # overlapping property types.
        distinct_property_types: dict[int, PropertyType] = {
            property_type.id: property_type
            for material_type in material_types
            for property_type in material_type.property_types
        }
        return self.serialize(list(distinct_property_types.values()))
