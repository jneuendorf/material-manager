from pathlib import Path

from flask import abort, make_response, render_template, url_for
from flask_apispec import use_kwargs
from flask_jwt_extended import current_user
from flask_weasyprint import HTML, render_pdf

from core.helpers.resource import BaseResource, ModelListResource, ModelResource
from core.helpers.schema import BaseSchema, ModelConverter
from extensions.user.decorators import login_required
from extensions.user.models import User

from . import models

# from marshmallow import fields


class RentalSchema(BaseSchema):
    class Meta:
        model_converter = ModelConverter
        model = models.Rental

    # fields = (
    # "id",
    # "user_id",
    # "material_id",)


class Rental(ModelResource):
    url = ["/rental", "/rental/<int:rental_id>"]
    Schema = RentalSchema

    # Adds a new rental /rental
    @use_kwargs(
        RentalSchema.to_dict()
        # {"id": fields.Int(required=True),
        # "material_id": fields.Int(required=True),
        # We do not have material_id in rental model !
        # "": fields.Str(required=True),}
    )
    def post(self, **kwargs) -> dict:
        """Test with
        curl -X POST "http://localhost:5000/rental" \
        -H 'Content-Type: application/json' \
        -d '{}'
        """
        rental = models.Rental.create(**kwargs)
        return self.serialize(rental)

    # update a rental by using rental_id
    @use_kwargs(RentalSchema.to_dict())
    def put(self, rental_id, **kwargs):
        rental = models.Rental.get(id=rental_id)
        rental_to_update = models.Rental.update(rental, **kwargs)
        return self.serialize(rental_to_update)


# Fetches all rentals.
class Rentals(ModelListResource):
    url = "/rentals"
    Schema = RentalSchema

    def get(self):
        rentals = models.Rental.all()
        return self.serialize(rentals)


def render_rental_confirmation(
    rental: models.Rental,
    total_price: float,
    logo_url: str,
    lang: str,
):
    return render_template(
        f"rental_confirmation-{lang}.html",  # noqa
        # Avoid as many internal requests as possible
        # TODO: Shrink styles
        bootstrap=(Path(__file__).parent / "static" / "bootstrap.min.css").read_text(),
        logo_url=logo_url,
        rental=rental,
        total_price=total_price,
    )


class RentalConfirmationPdf(BaseResource):
    url = [
        "/rental/<int:rental_id>/confirmation",
        "/rental/<int:rental_id>/confirmation/<string:lang>",
    ]

    @login_required
    def get(self, rental_id: int, lang: str = "de"):
        user: User = current_user
        rental: models.Rental = models.Rental.get(id=rental_id)
        if rental.customer.id != user.id:
            return abort(403, "Permission denied")

        rental = models.Rental.get(id=rental_id)
        return render_pdf(
            HTML(
                string=render_rental_confirmation(
                    rental,
                    logo_url=url_for("rental.static", filename="jdav-logo.jpg"),
                    total_price=(
                        sum(m.rental_fee for m in rental.materials)
                        + rental.deposit
                        - rental.discount
                    ),
                    lang=lang,
                ),
            ),
        )


class RentalConfirmationHtml(BaseResource):
    url = "/rental/<int:rental_id>/confirmation.html"

    def get(self, rental_id: int):
        from flask import current_app

        if not current_app.debug:
            abort(500, "debug only")

        rental = models.Rental.get(id=rental_id)
        return make_response(
            render_rental_confirmation(
                rental=rental,
                logo_url=url_for("rental.static", filename="jdav-logo.jpg"),
                total_price=(
                    sum(m.rental_fee for m in rental.materials)
                    + rental.deposit
                    - rental.discount
                ),
                lang="de",
            ),
        )
