from extensions.material.models import Condition, Material


def test_create_material(client, app) -> None:
    material_type = client.put(
        "/material_types",
        json={
            "name": "helmet",
            "description": "helmet description",
        },
    ).json
    material = client.put(
        "/materials",
        json={
            "material_type_id": material_type["id"],
            "inventory_number": "12345",
            "max_life_expectancy": "2 years",
            "max_service_duration": "1 year",
            "installation_date": "2021-01-01",
            "instructions": "Some instructions...",
            "next_inspection_date": "2022-01-01",
            "rental_fee": 12.34,
            "condition": Condition.OK.name,
            "days_used": 5,
            "serial_numbers": [
                {
                    "serial_number": "9876",
                    "production_date": "2020-01-01",
                    "manufacturer": "Amazon",
                }
            ],
        },
    ).json

    with app.app_context():
        assert Material.get(id=material["id"]) is not None
