from flask_apispec import use_kwargs
from marshmallow import fields

from core.helpers.resource import ModelListResource, ModelResource

from .models import Material as MaterialModel
from .models import MaterialType as MaterialTypeModel


class MaterialType(ModelResource):
    url = "/material_type/<int:type_id>"

    class Meta:
        model = MaterialTypeModel
        fields = ("id", "name", "description")

    def get(self, type_id: int):
        """Test with
        curl -X GET "http://localhost:5000/material_type/1"
        """
        material_type = MaterialTypeModel.get(id=type_id)
        return self.serialize(material_type)


class MaterialTypes(ModelListResource):
    url = "/material_types"

    class Meta:
        model = MaterialTypeModel
        fields = ("id", "name", "description")

    def get(self):
        material_types = models.MaterialType.all()
        return self.serialize(material_types)

    @use_kwargs(
        {
            "name": fields.Str(required=True),
            "description": fields.Str(required=True),
        }
    )
    def put(self, **kwargs) -> dict:
        """Test with
        curl -X PUT "http://localhost:5000/material_types" -H 'Content-Type: application/json' -d '{"name":"Seile", "description":"Seil zum Klettern"}'
        """  # noqa
        material_type = MaterialTypeModel.create(**kwargs)
        return self.serialize_single(material_type)


class Material(ModelResource):
    url = "/material/<int:material_id>"

    class Meta:
        model = MaterialModel
        fields = (
            "id",
            "material_type_id",
            "inventory_number",
            "max_life_expectancy",
            "max_service_duration",
            "installation_date",
            "instructions",
            "next_inspection_date",
            "rental_fee",
            "condition",
            "days_used",
        )

    def get(self, material_id: int):
        """Test with
        curl -X GET "http://localhost:5000/material/1"
        """
        material = MaterialModel.get(id=material_id)
        return self.serialize(material)


# class PurchaseDetailsSchema(Schema):
#     purchase_date = fields.DateTime()
#     invoice_number = fields.Str()
#     merchant = fields.Str()
#     purchase_price = fields.Float()
#     suggested_retail_price = fields.Float()


class Materials(ModelListResource):
    url = "/materials"

    class Meta:
        model = MaterialModel
        fields = (
            "id",
            "material_type_id",
            "inventory_number",
            "max_life_expectancy",
            "max_service_duration",
            "installation_date",
            "instructions",
            "next_inspection_date",
            "rental_fee",
            "condition",
            "days_used",
        )

    def get(self):
        materials = MaterialModel.all()
        return self.serialize(materials)

    @use_kwargs(
        {
            "material_type_id": fields.Integer(),
            "inventory_number": fields.Integer(),
            "max_life_expectancy": fields.Str(),
            "max_service_duration": fields.Str(),
            "installation_date": fields.DateTime(),
            "instructions": fields.Str(),
            "next_inspection_date": fields.DateTime(),
            "rental_fee": fields.Float(),
            "condition": fields.Str(),
            "days_used": fields.Integer(),
            # "purchase_details": fields.Nested(PurchaseDetailsSchema(only=(
            # "purchase_date", "invoice_number", "merchant", "purchase_price", "suggested_retail_price"))),
        }
    )
    def put(self, **kwargs) -> dict:
        """Test with
        curl -X PUT 'http://localhost:5000/materials' -H 'Content-Type: application/json' -d '{
            "material_type_id":"2", "inventory_number":"56565656", "max_life_expectancy":"50",
            "max_service_duration":"20", "installation_date":"2014-12-22T03:12:58.019077+00:00",
            "instructions":"use it like this and that", "next_inspection_date":"2014-12-22T03:12:58.019077+00:00",
            "rental_fee":"20", "condition":"OK", "days_used":"5"}'
        """  # noqa
        material = MaterialModel.create(**kwargs)
        return self.serialize_single(material)

    # curl -X PUT 'http://localhost:5000/material_types' -H 'Content-Type: application/json' -d '{
    # "material_type_id":"2", "inventory_number":"56565656", "max_life_expectancy":"50",
    # "max_service_duration":"20", "installation_date":"2014-12-22T03:12:58.019077+00:00",
    # "instructions":"use it like this and that", "next_inspection_date":"2014-12-22T03:12:58.019077+00:00",
    # "rental_fee":"20", "condition":"OK", "days_used":"5", "purchase_details":
    # {"purchase_date":"2014-12-22T03:12:58.019077+00:00", "invoice_number":"31", "merchant":"Merchentt bla",
    # "purchase_price":"55", "suggested_retail_price":"130" }}'
