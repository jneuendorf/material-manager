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
colors = ["rot", "grün", "blau", "gelb"]
material_types = ["helm", "seil", "carabiner", "kletterpickel"]
manufacturers = ["edelrid", "the blue light", "elliot", "black diamond"]
years_past = [2021, 2020, 2019, 2018, 2017, 2016, 2015, 2014]

# Create material sets
material_sets = [
    MaterialSet.get_or_create(set_name="bergtour"),
    MaterialSet.get_or_create(set_name="eiswand"),
    MaterialSet.get_or_create(set_name="wandern"),
    MaterialSet.get_or_create(set_name="zelten"),
]

# Create material types
for i in range(4):
    MaterialType.get_or_create(
        name=material_types[i],
        description="hier sollte eine beschreibung stehen",
        _related=dict(
            sets=[
                material_sets[i % 3],
                material_sets[(i + 1) % 3],
            ],
        ),
    )

# Create properties
for i in range(20):
    # create matching unit-value pairs for Property
    if i % 3 == 0:
        val = colors[(i + i % 5) % 3]
    else:
        val = str(i * i % 100)
    Property.get_or_create(
        name="name der eigenschaft",
        description="hier sollte eine Beschreibung stehen",
        value=val,
        unit=units[i % 3],
    )

# Create purchase details
for i in range(70):
    PurchaseDetails.get_or_create(
        purchase_date=datetime.date(
            years_past[i * 3 % 7], i * 2 % 12 + 1, i * 5 % 29 + 1
        ),
        invoice_number=inventory_identifier[i % 3]
        + str(i * 5)
        + inventory_identifier[(i + 1) % 3]
        + str(i * i),
        merchant=merchants[i % 3],
        purchase_price=float(i * 5 % 100) + float(0.01 * i % 100) + 10.0,
        suggested_retail_price=1.2 * float(i * 5 % 100) + float(0.01 * i % 100) + 10.0,
    )

# Create materials
for i in range(200):
    # create mostly ok condition, some repair, rarely broken for Material.condition
    if i % 50 == 0:
        condition = Condition.BROKEN
    elif i % 20 == 0:
        condition = Condition.REPAIR
    else:
        condition = Condition.OK

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
    material_type = MaterialType.get_or_create(id=i % 4)
    purchase_details = PurchaseDetails.get_or_create(id=i % 71)
    serial_number = SerialNumber.get_or_create(id=i % 30)
    material_property = Property.get_or_create(id=i % 21)

    Material.get_or_create(
        inventory_number=inventory_identifier[i % 3] + str(i * 3 % 100),
        max_life_expectancy=i % 9 + 1,
        max_service_duration=i % 5 + 1,
        installation_date=datetime.date(
            years_past[i * 4 % 7], i * 3 % 12 + 1, i * 2 % 29 + 1
        ),
        instructions="hier sollte eine gebrauchsanweisung stehen",
        next_inspection_date=datetime.date(2023, i * 3 % 12 + 1, i * 4 % 29 + 1),
        rental_fee=float(i * 2 % 40) + float(0.01 * i % 100) + 5.0,
        condition=condition,
        days_used=i * 5 % 100,
        _related=dict(
            material_type=material_type,
            purchase_details=purchase_details,
            serial_numbers=[ser_ID_original, serial_number],
            properties=[material_property],
        ),
    )
