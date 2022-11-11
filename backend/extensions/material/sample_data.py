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
units = ["farbe", "kg", "meter", "cm"]
farben = ["rot", "grün", "blau", "gelb"]
set_names = ["bergtour", "eiswand", "wandern", "zelten"]
material_types = ["helm", "seil", "carabiner", "kletterpickel"]
manufacturers = ["edelrid", "the blue light", "elliot", "black diamont"]
years_future = [2023, 2024, 2025, 2026]
years_past = [2021, 2020, 2019, 2018, 2017, 2016, 2015, 2014]

# create 4 different material sets to use in material type relationships
set_ID0 = MaterialSet.get_or_create(id=0, set_name=set_names[0])
set_ID1 = MaterialSet.get_or_create(id=1, set_name=set_names[1])
set_ID2 = MaterialSet.get_or_create(id=2, set_name=set_names[2])
set_ID3 = MaterialSet.get_or_create(id=3, set_name=set_names[3])
set_IDs = [set_ID0, set_ID1, set_ID2, set_ID3]

i = 0

# create 201 materials with a serial number each
while i <= 200:

    # create mostly ok condition, some repair, rarely broken for Material.condition
    if i % 50 == 0:
        new_condition = Condition.BROKEN
    elif i % 20 == 0:
        new_condition = Condition.REPAIR
    else:
        new_condition = Condition.OK

    # create 70 different purchase details
    if i <= 70:

        pur_ID = PurchaseDetails.get_or_create(
            id=i,
            purchase_date=datetime.date(
                years_past[i * 3 % 7], i * 2 % 12 + 1, i * 5 % 29 + 1
            ),
            invoice_number=inventory_identifier[i % 3]
            + str(i * 5)
            + inventory_identifier[(i + 1) % 3]
            + str(i * i),
            merchant=merchants[i % 3],
            purchase_price=float(i * 5 % 100) + float(0.01 * i % 100) + 10.0,
            suggested_retail_price=1.2 * float(i * 5 % 100)
            + float(0.01 * i % 100)
            + 10.0,
        )

        # create 21 properties
        if i <= 20:
            # create matching unit-value pairs for Property
            if i % 3 == 0:
                val = farben[(i + i % 5) % 3]
            else:
                val = str(i * i % 100)
            pro_ID = Property.get_or_create(
                id=i,
                name="name der eigenschaft",
                description="hier sollte eine Beschreibung stehen",
                value=val,
                unit=units[i % 3],
            )

            # create 4 different material types
            if i <= 3:
                mat_ID = MaterialType.get_or_create(
                    id=i,
                    name=material_types[i],
                    description="hier sollte eine beschreibung stehen",
                    _related=dict(sets=[set_IDs[i % 3], set_IDs[(i + 1) % 3]]),
                )

    ser_ID_original = SerialNumber.get_or_create(
        id=i,
        serial_number=i,
        production_date=datetime.date(
            years_past[i * 2 % 7], i * 3 % 12 + 1, i * 4 % 29 + 1
        ),
        manufacturer=manufacturers[i % 3],
        material_id=i,
    )

    # create IDs for relationships
    mat_ID = MaterialType.get_or_create(id=i % 4)
    pur_ID = PurchaseDetails.get_or_create(id=i % 71)
    ser_ID = SerialNumber.get_or_create(id=i % 30)
    pro_ID0 = Property.get_or_create(id=i % 21)

    Material.get_or_create(
        id=i,
        inventory_number=inventory_identifier[i % 3] + str(i * 3 % 100),
        max_life_expectancy=i % 9 + 1,
        max_service_duration=i % 5 + 1,
        installation_date=datetime.date(
            years_past[i * 4 % 7], i * 3 % 12 + 1, i * 2 % 29 + 1
        ),
        instructions="hier sollte eine gebrauchsanweisung stehen",
        next_inspection_date=datetime.date(2023, i * 3 % 12 + 1, i * 4 % 29 + 1),
        rental_fee=float(i * 2 % 40) + float(0.01 * i % 100) + 5.0,
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
