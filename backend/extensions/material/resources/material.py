from flask_marshmallow.sqla import SQLAlchemySchema
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import DeclarativeMeta

from backend.core.helpers import ModelListResource, ModelResource, with_db


def define_material_resources(db: SQLAlchemy, MaterialModel: DeclarativeMeta):
    @with_db(db)
    class MaterialResource(ModelResource):
        urls = ("/material/<int:material_id>",)

        class Schema(SQLAlchemySchema):
            class Meta:
                model = MaterialModel
                fields = ("id", "first_name", "last_name")

        def get(self, material_id: int) -> dict:
            material = self.orm.get(id=material_id)
            return self.schema.dump(material)

    @with_db(db)
    class MaterialListResource(ModelListResource):
        urls = ("/materials",)

        class Schema(SQLAlchemySchema):
            class Meta:
                model = MaterialModel
                fields = ("id", "last_name")

        def get(self) -> list[dict]:
            materials = self.orm.all()
            return self.schema.dump(materials)

    return (
        MaterialResource,
        MaterialListResource,
    )
