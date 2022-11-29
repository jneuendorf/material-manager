from flask_apispec import use_kwargs
from marshmallow import fields

from core.helpers.resource import ModelListResource, ModelResource
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
    url = [
        "/rental"
        # "/rental/<int:rental_id>"
    ]
    Schema = RentalSchema

    # Adds a new rental /rental
    @use_kwargs(
        {
            "id": fields.Int(required=True),
            # "material_id": fields.Int(required=True),
            # We do not have material_id in rental model !
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

    # To Do
    # update a rental by using rental_id


# Fetches all rentals.
class Rentals(ModelListResource):
    url = "/rentals"
    Schema = RentalSchema

    def get(self):
        rentals = models.Rental.all()
        return self.serialize(rentals)
