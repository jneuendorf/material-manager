from flask_apispec import use_kwargs
from marshmallow import fields

from core.helpers.resource import ModelResource  # , ModelListResource
from core.helpers.schema import BaseSchema  # , ModelConverter

from . import models


class RentalSchema(BaseSchema):
    class Meta:
        model = models.Rental
        fields = (
            # "id",
            # "user_id",
            # "material_id",
        )


class Rental(ModelResource):
    url = "/rental"
    Schema = RentalSchema

    @use_kwargs(
        {
            "id": fields.Int(required=True),
            "material_id": fields.Int(required=True),
            # "": fields.Str(required=True),
        }
    )
    def post(self, **kwargs) -> dict:
        """Test with
        curl -X POST "http://localhost:5000/rental" \
        -H 'Content-Type: application/json' \
        -d '{}'
        """
        rental = models.Rental.create(**kwargs)
        return self.serialize(rental)
