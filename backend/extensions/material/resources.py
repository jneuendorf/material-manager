from flask_apispec import use_kwargs
from marshmallow import fields

from core.helpers.resource import ModelListResource, ModelResource

from .models import EquipmentType as EquipmentTypeModel
from .models import Material as MaterialModel


class EquipmentType(ModelResource):
    url = "/equipment_type/<int:type_id>"

    class Meta:
        model = EquipmentTypeModel
        fields = ("id", "name", "description")

    def get(self, type_id: int):
        """Test with
        curl -X GET "http://localhost:5000/equipment_type/1"
        """
        Equipment_type = EquipmentTypeModel.get(id=type_id)
        return self.serialize(Equipment_type)


class EquipmentTypes(ModelListResource):
    url = "/equipment_types"

    class Meta:
        model = EquipmentTypeModel
        fields = ("id", "name", "description")

    def get(self):
        equipment_types = EquipmentTypeModel.all()
        return self.serialize(equipment_types)

    @use_kwargs(
        {
            "id": fields.Integer(),
            "name": fields.Str(),
            "description": fields.Str(),
        }
    )
    def put(self, **kwargs) -> dict:
        """Test with"""  # noqa
        equipment_type = EquipmentTypeModel.create(**kwargs)
        return self.schema.dump(equipment_type, many=False)


class Material(ModelResource):
    url = "/{ext_name}/<int:material_id>"

    class Meta:
        model = MaterialModel
        fields = (
            "id",
            "equipment_type_id",
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
    url = "/{ext_name}s"

    class Meta:
        model = MaterialModel
        fields = (
            "id",
            "equipment_type_id",
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
            "equipment_type_id": fields.Integer(),
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
            "equipment_type_id":"2", "inventory_number":"56565656", "max_life_expectancy":"50",
            "max_service_duration":"20", "installation_date":"2014-12-22T03:12:58.019077+00:00",
            "instructions":"use it like this and that", "next_inspection_date":"2014-12-22T03:12:58.019077+00:00",
            "rental_fee":"20", "condition":"very good","days_used":"5"}'
        """  # noqa
        material = MaterialModel.create(**kwargs)
        return self.schema.dump(material, many=False)

    # curl -X PUT 'http://localhost:5000/equipment_types' -H 'Content-Type: application/json' -d '{
    # "equipment_type_id":"2", "inventory_number":"56565656", "max_life_expectancy":"50",
    # "max_service_duration":"20", "installation_date":"2014-12-22T03:12:58.019077+00:00",
    # "instructions":"use it like this and that", "next_inspection_date":"2014-12-22T03:12:58.019077+00:00",
    # "rental_fee":"20", "condition":"very good","days_used":"5", "purchase_details":
    # {"purchase_date":"2014-12-22T03:12:58.019077+00:00", "invoice_number":"31", "merchant":"Merchentt bla",
    # "purchase_price":"55", "suggested_retail_price":"130" }}'
