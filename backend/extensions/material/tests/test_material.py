from datetime import date

from extensions.material.models import Condition, Material


def test_create_and_fetch_material(client, app) -> None:
    material_type = client.post(
        "/material_type",
        json={
            "name": "helmet",
            "description": "helmet description",
        },
    ).json
    serial_number9876 = {
        "serial_number": "9876",
        "production_date": "2020-01-01",
        "manufacturer": "Amazon",
    }
    material = client.post(
        "/material",
        json={
            "name": "material name",
            "max_operating_years": 1.1,
            "max_days_used": 365,
            "installation_date": "2021-01-01",
            "instructions": "Some instructions...",
            "next_inspection_date": "2022-01-01",
            "rental_fee": 12.34,
            "condition": Condition.OK.name,
            "days_used": 5,
            "material_type": material_type,
            "serial_numbers": [serial_number9876],
        },
    ).json

    # Check DB data
    with app.app_context():
        material_instance = Material.get(id=material["id"])
        assert material_instance.installation_date == date(2021, 1, 1)
        assert material_instance.condition == Condition.OK
        assert material_instance.material_type.name == "helmet"
        assert len(material_instance.serial_numbers) == 1
        assert material_instance.serial_numbers[0].serial_number == "9876"
        assert not material_instance.purchase_details

    # Check API data
    material = client.get(f"/material/{material['id']}").json
    assert material["material_type"] == material_type
    assert material["serial_numbers"] == [serial_number9876]


def test_creating_materials_ensures_no_duplicate_serial_numbers(client, app):
    material_type = client.post(
        "/material_type",
        json={
            "name": "belt",
            "description": "belt description",
        },
    ).json
    response = client.post(
        "/material",
        json={
            "name": "material name",
            "max_operating_years": 1,
            "max_days_used": 365,
            "installation_date": "2021-01-01",
            "instructions": "Some instructions...",
            "next_inspection_date": "2022-01-01",
            "rental_fee": 12.34,
            "condition": Condition.OK.name,
            "days_used": 5,
            "material_type": material_type,
            "serial_numbers": [
                {
                    "serial_number": "9876",
                    "production_date": "2020-01-01",
                    "manufacturer": "Amazon",
                },
                {
                    "serial_number": "9876",
                    "production_date": "2020-02-01",
                    "manufacturer": "Amazon",
                },
            ],
        },
    )
    assert response.status_code == 403

    # Same serial number of different manufacturers should be ok
    response = client.post(
        "/material",
        json={
            "name": "material name",
            "max_operating_years": 1.5,
            "max_days_used": 365,
            "installation_date": "2021-01-01",
            "instructions": "Some instructions...",
            "next_inspection_date": "2022-01-01",
            "rental_fee": 12.34,
            "condition": Condition.OK.name,
            "days_used": 5,
            "material_type": material_type,
            "serial_numbers": [
                {
                    "serial_number": "9876",
                    "production_date": "2020-01-01",
                    "manufacturer": "Amazon",
                },
                {
                    "serial_number": "9876",
                    "production_date": "2020-02-01",
                    "manufacturer": "Stubai",
                },
            ],
        },
    )
    assert response.status_code == 200


def test_bulk_create_materials(client, app) -> None:
    purchase_details = {
        "purchase_date": "2020-02-02",
        "invoice_number": "9723rnsdfn23",
        "merchant": "flying dutchman",
        "purchase_price": 13.37,
        "suggested_retail_price": 42,
    }

    num_materials = 2
    # https://gist.github.com/ondrek/7413434
    base64_image = "iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABlBMVEX///+/v7+jQ3Y5AAAADklEQVQI12P4AIX8EAgALgAD/aNpbtEAAAAASUVORK5CYII="  # noqa

    created_materials = client.post(
        "/materials",
        json={
            "serial_numbers": [
                [
                    {
                        "serial_number": f"s-{i_mat}-{i_sn}",
                        "production_date": "2020-01-01",
                        "manufacturer": f"manufacturer_{i_mat}",
                    }
                    for i_sn in range(2)
                ]
                for i_mat in range(num_materials)
            ],
            "inventory_numbers": [
                {
                    "inventory_number": f"i-{i_mat}",
                }
                for i_mat in range(num_materials)
            ],
            "images": [
                {
                    "base64": base64_image,
                    "filename": "mini chess.png",
                    "mime_type": "image/png",
                }
            ],
            "material_type": {
                "name": "some new material type",
            },
            "purchase_details": purchase_details,
            "properties": [
                {
                    "property_type": {
                        "name": "length",
                        "unit": "cm",
                    },
                    "value": "10",
                },
                {
                    "property_type": {
                        "name": "color",
                        "unit": "",
                    },
                    "value": "blue",
                },
            ],
            "max_operating_years": 4,
            "max_days_used": 200,
            "instructions": "https://en.wikipedia.org/wiki/PDF",
            "next_inspection_date": "2022-01-01",
            "rental_fee": 12.34,
        },
    ).json

    assert "materials" in created_materials
    with app.app_context():
        for material_id in created_materials["materials"]:
            material = Material.get_or_none(id=material_id)
            assert material is not None
            assert (
                material.purchase_details.invoice_number
                == purchase_details["invoice_number"]
            )

    # Create materials with existing properties
    created_materials = client.post(
        "/materials",
        json={
            "serial_numbers": [
                [
                    {
                        "serial_number": "s-0-9999",
                        "production_date": "2020-01-01",
                        "manufacturer": "manufacturer_0",
                    }
                ]
            ],
            "inventory_numbers": [
                {
                    "inventory_number": "i-9999",
                }
            ],
            "images": [
                {
                    "base64": base64_image,
                    "filename": "mini chess.png",
                    "mime_type": "image/png",
                }
            ],
            "material_type": {
                "name": "helmet",
            },
            "purchase_details": purchase_details,
            "properties": [
                {
                    "property_type": {
                        "name": "length",
                        "unit": "cm",
                    },
                    "value": "10",
                },
                {
                    "property_type": {
                        "name": "some new property type",
                        "unit": "sheep",
                    },
                    "value": "4",
                },
            ],
            "max_operating_years": 6,
            "max_days_used": 200,
            "instructions": "https://en.wikipedia.org/wiki/PDF",
            "next_inspection_date": "2022-01-01",
            "rental_fee": 1337,
        },
    ).json

    # TEAR DOWN
    with app.app_context():
        for material_id in created_materials["materials"]:
            material = Material.get_or_none(id=material_id)
            for image in material.images:
                image.delete()
