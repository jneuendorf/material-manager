from datetime import date

from extensions.material.models import Condition, Material, PurchaseDetails


def test_create_material(client, app) -> None:
    material_type = client.put(
        "/material_types",
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
    material = client.put(
        "/materials",
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


def test_create_purchase_details(client, app) -> None:
    purchase_detail = client.put(
        "/purchase_details",
        json={
            "purchase_date": "2022-11-02",
            "invoice_number": "21589u4rhr",
            "merchant": "Der Händler",
            "purchase_price": "300.45",
            "suggested_retail_price": "238.37",
        },
    ).json

    # Check DB data
    with app.app_context():
        # print("purchase details Id: ", purchase_detail["id"])
        purchase_detail_instance = PurchaseDetails.get(id=purchase_detail["id"])
        assert purchase_detail_instance.purchase_date == date(2022, 11, 2)
        assert purchase_detail_instance.invoice_number == "21589u4rhr"
        assert purchase_detail_instance.merchant == "Der Händler"
        assert purchase_detail_instance.purchase_price == 300.45
        assert purchase_detail_instance.suggested_retail_price == 238.37
