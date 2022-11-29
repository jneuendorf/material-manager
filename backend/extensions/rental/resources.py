from pathlib import Path

from flask import abort, make_response, render_template, url_for
from flask_jwt_extended import current_user
from flask_weasyprint import HTML, render_pdf

from core.helpers.resource import BaseResource
from extensions.rental.models import Rental
from extensions.user.decorators import login_required
from extensions.user.models import User


def render_rental_confirmation(
    rental: Rental,
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
        rental: Rental = Rental.get(id=rental_id)
        if rental.customer.id != user.id:
            return abort(403, "Permission denied")

        rental = Rental.get(id=rental_id)
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

        rental = Rental.get(id=rental_id)
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
