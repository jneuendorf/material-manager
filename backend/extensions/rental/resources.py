from datetime import date
from pathlib import Path
from typing import Optional

from flask import abort, current_app, make_response, render_template, url_for
from flask_apispec import use_kwargs
from flask_jwt_extended import current_user
from flask_weasyprint import HTML, render_pdf
from marshmallow import fields

from core.helpers.resource import BaseResource, ModelListResource, ModelResource
from core.helpers.schema import BaseSchema, ModelConverter
from extensions.material.models import Material
from extensions.material.resources.schemas import MaterialSchema
from extensions.user.decorators import login_required
from extensions.user.models import User
from extensions.user.resources import UserSchema

from . import models


class RentalSchema(BaseSchema):
    lender = fields.Nested(UserSchema(only=["id"]))
    customer = fields.Nested(UserSchema(only=["id"]))
    return_to = fields.Nested(UserSchema(only=["id"]))
    materials = fields.List(fields.Nested(MaterialSchema(only=["id"])))

    class Meta:
        model_converter = ModelConverter
        model = models.Rental


class Rental(ModelResource):
    url = ["/rental", "/rental/<int:rental_id>"]
    Schema = RentalSchema

    # Adds a new rental /rental
    @use_kwargs(
        {
            **RentalSchema.to_dict(
                include=[
                    "customer",
                    "lender",
                    "materials",
                    "cost",
                    "discount",
                    "deposit",
                    "start_date",
                    "end_date",
                    "usage_start_date",
                    "usage_end_date",
                ],
            ),
        }
    )
    def post(
        self,
        customer: User,
        lender: User,
        materials: list[Material],
        cost: float,
        discount: float,
        deposit: float,
        start_date: date,
        end_date: date,
        usage_start_date: Optional[date] = None,
        usage_end_date: Optional[date] = None,
    ) -> dict:
        """Test with
        curl -X POST "http://localhost:5000/rental" \
        -H 'Content-Type: application/json' \
        -d '{}'
        """
        rental = models.Rental.create(
            _related=dict(
                customer=customer,
                lender=lender,
                materials=materials,
            ),
            cost=cost,
            discount=discount,
            deposit=deposit,
            start_date=start_date,
            end_date=end_date,
            usage_start_date=usage_start_date,
            usage_end_date=usage_end_date,
        )
        return {
            "id": rental.id,
        }

    # update a rental by using rental_id
    @use_kwargs(RentalSchema.to_dict(exclude=["id", "created_at"]))
    def put(self, rental_id, **kwargs):
        if not kwargs["materials"]:
            abort(400, "A rental requires related materials")
        rental = models.Rental.get(id=rental_id)
        rental.update(**kwargs)
        return self.serialize(rental)

    def get(self, rental_id: int):
        """Test with
        curl -X GET "http://localhost:5000/rental/1"
        """
        rental = models.Rental.get(id=rental_id)
        return self.serialize(rental)


# Fetches all rentals.
class Rentals(ModelListResource):
    url = "/rentals"
    Schema = RentalSchema

    def get(self):
        rentals = models.Rental.all()
        return self.serialize(rentals)


TRANSLATIONS = {
    "Rental Confirmation": "Leihschein",
    "Rental confirmation for": "Leihschein für",
    "Membership number": "Mitgliedsnummer",
    "E-mail": "E-Mail",
    "Phone": "Tel.",
    "Invoice number": "Rechungsnummer",
    "Rental period": "Ausleihzeitraum",
    "Planned return": "Geplante Rückgabe",
    "Rented equipment": "Ausgeliehenes Material",
    "Description": "Beschreibung",
    "Price": "Preis",
    "Condition on return": "Zustand bei Rückgabe",
    "Returned": "Rückgabe erfolgt",
    "Instructions": "Anleitung",
    "Deposit": "Kaution",
    "Discount": "Rabatt",
    "Received on": "Empfangen am",
    "I accept the": "Ich akzeptiere die Bedingungen in der",
    "terms and conditions": "Ausleihordnung",
    "Date": "Datum",
    "Signature": "Unterschrift",
    "Fill in on return": "Bei Rückgabe auszufüllen",
    "I controlled the equipment and made notice of any damages": "Ich habe eine Sichtkontrolle durchgeführt, Mängel oben notiert und gemeldet",  # noqa
    "To be filled by the issuer": "Vom Verleih auszufüllen",
    "Equipment returned completely": "Material vollständig zurück",
    "Returned on": "Rückgabe am",
}


def translator(lang: str):
    if lang == "en":
        return lambda s: s
    elif lang == "de":
        return lambda s: TRANSLATIONS.get(s, s)
    else:
        raise ValueError(f"invalid language {lang}")


def render_rental_confirmation(
    rental: models.Rental,
    total_price: float,
    logo_url: str,
    lang: str,
):
    return render_template(
        f"rental_confirmation.html",  # noqa
        lang=lang,
        # TODO: jinja2.ext.i18n
        _=translator(lang),
        # TODO: Shrink styles
        bootstrap=(
            Path(__file__).parent / "static/bootstrap.min.css"
        ).read_text(),  # Avoid as many internal requests as possible
        logo_url=logo_url,
        # TODO: take this from some other model
        issuer="JDAV Sektion Berlin",
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
