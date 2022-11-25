from typing import Any

from flask import abort, render_template
from flask_jwt_extended import current_user
from flask_weasyprint import HTML, render_pdf

from core.helpers.resource import BaseResource
from extensions.rental.models import Rental
from extensions.user.decorators import login_required
from extensions.user.models import User


class RentalConfirmation(BaseResource):
    url = "/rental/<int:rental_id>/confirmation"

    @login_required
    def get(self, rental_id: int):
        user: User = current_user
        rental: Rental = Rental.get(id=rental_id)
        if rental.customer.id != user.id:
            return abort(403, "Permission denied")

        context: dict[str, Any] = {}
        html = render_template("rental_confirmation.html", **context)
        return render_pdf(HTML(string=html))
