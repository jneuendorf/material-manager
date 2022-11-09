import datetime

from extensions.material.models import (
    Condition,
    Material,
    MaterialSet,
    MaterialType,
    Property,
    PurchaseDetails,
    SerialNumber,
)

inventory_identifier = ["J", "K", "L", "G"]
merchants = ["InterSport", "Globetrotter", "SecondHand", "Amazon"]
units = ["g", "kg", "meter", "cm"]
set_names = ["bergtour", "eiswand", "wandern", "zelten"]
material_types = ["gold", "silber", "bronze", "holz"]
manufacturers = ["edelrid", "the blue light", "elliot", "black diamont"]
years_future = [2023, 2024, 2025, 2026]
years_past = [2021, 2020, 2019, 2018, 2017, 2016, 2015, 2014]

i = 0

while i <= 200:

    if i % 50 == 0:
        new_condition = Condition.BROKEN
    elif i % 20 == 0:
        new_condition = Condition.REPAIR
    else:
        new_condition = Condition.OK

    if i <= 70:

        pur_ID = PurchaseDetails.get_or_create(
            id=i,
            purchase_date=datetime.date(
                years_past[i * 3 % 7], i * 2 % 12 + 1, i * 5 % 29 + 1
            ),
            invoice_number=inventory_identifier[i % 3] + str(i * 5),
            merchant=merchants[i % 3],
            purchase_price=float(i * 5 % 100) + float(0.01 * i % 100),
            suggested_retail_price=float(i * 3 % 100) + float(0.01 * i % 80),
        )

        if i <= 20:
            pro_ID = Property.get_or_create(
                id=i,
                name="TODO",
                description="hier sollte eine Beschreibung stehen",
                value=i * i % 100,
                unit=units[i % 3],
            )

            if i <= 3:
                mat_ID = MaterialType.get_or_create(
                    id=i,
                    name=material_types[i],
                    description="shiny",
                    _related=dict(
                        # sets=
                    ),
                )
                MaterialSet.get_or_create(id=i, set_name=set_names[i])

    ser_ID_original = SerialNumber.get_or_create(
        id=i,
        serial_number=i,
        production_date=datetime.date(
            years_past[i * 2 % 7], i * 3 % 12 + 1, i * 4 % 29 + 1
        ),
        manufacturer=manufacturers[i % 3],
        material_id=i,
    )

    mat_ID = MaterialType.get_or_create(id=i % 4)
    pur_ID = PurchaseDetails.get_or_create(id=i % 71)
    ser_ID = SerialNumber.get_or_create(id=i % 30)
    pro_ID0 = Property.get_or_create(id=i % 21)

    Material.get_or_create(
        id=i,
        inventory_number=str(inventory_identifier[i % 3]) + str(i * 5 % 100),
        max_life_expectancy=i % 8,
        max_service_duration=i % 10,
        installation_date=datetime.date(
            years_past[i * 4 % 7], i * 3 % 12 + 1, i * 2 % 29 + 1
        ),
        instructions="hier sollte eine gebrauchsanweisung stehen",
        next_inspection_date=datetime.date(
            years_future[i * 2 % 3], i * 3 % 12 + 1, i * 4 % 29 + 1
        ),
        rental_fee=float(i * 2 % 40) + float(0.01 * i % 100),
        condition=new_condition,
        days_used=i * 5 % 100,
        # many to one (FK here)
        material_type_id=i % 4,
        # many to one (FK here)
        purchase_details_id=i & 71,
        _related=dict(
            material_type=mat_ID,
            purchase_details=pur_ID,
            serial_numbers=[ser_ID_original, ser_ID],
            properties=[pro_ID0],
        ),
    )

    i += 1
