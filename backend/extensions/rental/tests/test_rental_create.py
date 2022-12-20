from datetime import date

from extensions.material.models import Material, MaterialType, SerialNumber
from extensions.rental.models import Rental
from extensions.user.models import User


def test_create_rental(client, app) -> None:
    with app.app_context():
        rental_user = User.create_from_password(
            email="rental_user@localhost.com",
            password="rentaluser",
            first_name="Rudolph",
            last_name="Rental",
        )
        rental_user_id = rental_user.id
        rental_material = Material.get_or_create(
            name="for rental only",
            max_days_used=20,
            next_inspection_date=date(2022, 1, 1),
            rental_fee=1.23,
            _related=dict(
                material_type=MaterialType.get_or_create(
                    name="rental test stuff",
                ),
                serial_numbers=[
                    SerialNumber.get_or_create(
                        serial_number="uhfd923rn9wfoi23",
                        production_date=date(2022, 1, 1),
                        manufacturer="rental test manufacturer",
                    ),
                ],
            ),
        )
        rental_material_id = rental_material.id

    rental = client.post(
        "/rental",
        json={
            "customer": {"id": rental_user_id},
            "materials": [
                {
                    "id": rental_material_id,
                },
            ],
            "cost": 1.23,
            "deposit": 1,
            "discount": 0,
            "start_date": "2022-12-10",
            "end_date": "2022-12-13",
        },
    ).json

    # Check DB data
    with app.app_context():
        rental_instance = Rental.get(id=rental["id"])
        assert rental_instance.customer.id == rental_user_id

    # Check API data
    rental = client.get(f"/rental/{rental['id']}").json
    assert rental["customer"]["id"] == rental_user_id
