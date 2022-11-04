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
            "inventory_number": "12345",
            "max_life_expectancy": "2 years",
            "max_service_duration": "1 year",
            "installation_date": "2021-01-01",
            "instructions": "Some instructions...",
            "next_inspection_date": "2022-01-01",
            "rental_fee": 12.34,
            "condition": Condition.OK.name,
            "days_used": 5,
            "material_type_id": material_type["id"],
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
            "inventory_number": "12345",
            "max_life_expectancy": "2 years",
            "max_service_duration": "1 year",
            "installation_date": "2021-01-01",
            "instructions": "Some instructions...",
            "next_inspection_date": "2022-01-01",
            "rental_fee": 12.34,
            "condition": Condition.OK.name,
            "days_used": 5,
            "material_type_id": material_type["id"],
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
            "inventory_number": "12345",
            "max_life_expectancy": "2 years",
            "max_service_duration": "1 year",
            "installation_date": "2021-01-01",
            "instructions": "Some instructions...",
            "next_inspection_date": "2022-01-01",
            "rental_fee": 12.34,
            "condition": Condition.OK.name,
            "days_used": 5,
            "material_type_id": material_type["id"],
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


# def test_create_and_fetch_purchase_details(client, app) -> None:
#     purchase_detail = client.post(
#         "/purchase_details",
#         json={
#             "purchase_date": "2022-11-02",
#             "invoice_number": "21589u4rhr",
#             "merchant": "Der Händler",
#             "purchase_price": "300.45",
#             "suggested_retail_price": "238.37",
#         },
#     ).json
#
#     # Check DB data
#     with app.app_context():
#         # print("purchase details Id: ", purchase_detail["id"])
#         purchase_detail_instance = PurchaseDetails.get(id=purchase_detail["id"])
#         assert purchase_detail_instance.purchase_date == date(2022, 11, 2)
#         assert purchase_detail_instance.invoice_number == "21589u4rhr"
#         assert purchase_detail_instance.merchant == "Der Händler"
#         assert purchase_detail_instance.purchase_price == 300.45
#         assert purchase_detail_instance.suggested_retail_price == 238.37


def test_bulk_create_materials(client, app) -> None:
    material_type = client.post(
        "/material_type",
        json={
            "name": "shoe",
            "description": "shoe description",
        },
    ).json
    materials_data = [
        {
            "inventory_number": "12345",
            "max_life_expectancy": "2 years",
            "max_service_duration": "1 year",
            "installation_date": "2021-01-01",
            "instructions": "Some instructions...",
            "next_inspection_date": "2022-01-01",
            "rental_fee": 12.34,
            "condition": Condition.OK.name,
            "days_used": 5,
            "material_type_id": material_type["id"],
            "serial_numbers": [
                {
                    "serial_number": f"xyz-{i}-{j}",
                    "production_date": "2020-01-01",
                    "manufacturer": "Stubai",
                }
                for i in range(3)
            ],
        }
        for j in range(4)
    ]
    purchase_details_data = {
        "purchase_date": "2020-02-02",
        "invoice_number": "9723rnsdfn23",
        "merchant": "flying dutchman",
        "purchase_price": 13.37,
        "suggested_retail_price": 42,
    }

    created_materials = client.post(
        "/materials",
        json={
            "materials": materials_data,
            "purchase_details": purchase_details_data,
        },
    ).json
    assert "materials" in created_materials
    with app.app_context():
        for material_id in created_materials["materials"]:
            material = Material.get_or_none(id=material_id)
            assert material is not None
            assert (
                material.purchase_details.invoice_number
                == purchase_details_data["invoice_number"]
            )