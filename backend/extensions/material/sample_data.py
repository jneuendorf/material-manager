import itertools as it
from datetime import date, timedelta
from hashlib import sha1

from extensions.material.models import (
    Condition,
    Material,
    MaterialSet,
    MaterialType,
    Property,
    PurchaseDetails,
    SerialNumber,
)

NUM_PROPERTIES = 18
NUM_PURCHASE_DETAILS = 30
NUM_MATERIALS = 50

INVENTORY_IDENTIFIERS = it.cycle(["J", "K", "L", "G"])
MERCHANTS = it.cycle(["InterSport", "Globetrotter", "SecondHand", "Amazon"])
PROPERTY_UNITS = it.cycle(["kg", "m", "cm"])
COLORS = it.cycle(["red", "green", "blue", "yellow"])
MANUFACTURERS = it.cycle(["edelrid", "the blue light", "elliot", "black diamond"])

# Create material sets
material_sets = {
    material_set.name: material_set
    for material_set in [
        MaterialSet.get_or_create(name="ice climbing"),
        MaterialSet.get_or_create(name="mountain face"),
        MaterialSet.get_or_create(name="hiking"),
        MaterialSet.get_or_create(name="camping"),
    ]
}

# Create material types
material_types = it.cycle(
    [
        MaterialType.get_or_create(
            name="helmet",
            description="helmet description",
            _related=dict(
                sets=[
                    material_sets["ice climbing"],
                    material_sets["mountain face"],
                ],
            ),
        ),
        MaterialType.get_or_create(
            name="rope",
            description="rope description",
            _related=dict(
                sets=[
                    material_sets["ice climbing"],
                    material_sets["mountain face"],
                    material_sets["hiking"],
                    material_sets["camping"],
                ],
            ),
        ),
        MaterialType.get_or_create(
            name="carabiner",
            description="carabiner description",
            _related=dict(
                sets=[
                    material_sets["ice climbing"],
                    material_sets["mountain face"],
                    material_sets["camping"],
                ],
            ),
        ),
        MaterialType.get_or_create(
            name="ice pick",
            description="ice pick description",
            _related=dict(
                sets=[
                    material_sets["ice climbing"],
                ],
            ),
        ),
    ]
)


# Create properties
def get_property_name(i: int) -> str:
    return f"property {i}"


for i in range(NUM_PROPERTIES):
    # create matching unit-value pairs for Property
    if i <= NUM_PROPERTIES // 3:
        value = next(COLORS)
        unit = "color"
    else:
        value = str(i * 1.03)
        unit = next(PROPERTY_UNITS)
    Property.get_or_create(
        name=get_property_name(i),
        description=f"property description {i}",
        value=value,
        unit=unit,
    )

# Create purchase details
created_purchase_details = []
for i in range(NUM_PURCHASE_DETAILS):
    price = (i + 1) ** 3
    created_purchase_details.append(
        PurchaseDetails.get_or_create(
            purchase_date=date(2022, 1, 1) + timedelta(days=i),
            invoice_number=(
                f"{next(INVENTORY_IDENTIFIERS)}-"
                f"{sha1(str(i).encode('utf-8')).hexdigest()[:6]}-"
                f"{next(INVENTORY_IDENTIFIERS)}"
            ),
            merchant=next(MERCHANTS),
            purchase_price=price,
            # Some SRP above and some below the purchase price
            suggested_retail_price=price + (-1) ** i,
        )
    )


# Create serial numbers
def get_serial_number_str(i: int) -> str:
    return f"sn-{i}-{i ** 2}"


for i in range(NUM_MATERIALS):
    SerialNumber.get_or_create(
        serial_number=get_serial_number_str(i),
        production_date=date(2022, 1, 1) + timedelta(days=i),
        manufacturer=next(MANUFACTURERS),
    )

# Create materials
for i in range(NUM_MATERIALS):
    # create mostly ok condition, some repair, rarely broken for Material.condition
    if i % 50 == 0:
        condition = Condition.BROKEN
    elif i % 20 == 0:
        condition = Condition.REPAIR
    else:
        condition = Condition.OK

    serial_numbers = [SerialNumber.get(serial_number=get_serial_number_str(i))]
    # Let some materials have multiple serial numbers
    if i > 100:
        serial_numbers.append(
            SerialNumber.get(serial_number=get_serial_number_str(i - 1))
        )

    installation_date = date(2022, 1, 1) + timedelta(days=i)
    Material.get_or_create(
        inventory_number=f"{next(INVENTORY_IDENTIFIERS)}-{i}",
        name=f"material {i}",
        installation_date=installation_date,
        max_life_expectancy=installation_date + timedelta(weeks=(-1) ** i * 2),
        max_lifespan=i % 5 + 1,
        instructions="hier sollte eine gebrauchsanweisung stehen",
        next_inspection_date=installation_date + timedelta(weeks=(-1) ** i),
        rental_fee=1.13 * (i + 1),
        condition=condition,
        days_used=i * 5 % 100,
        _related=dict(
            material_type=next(material_types),
            purchase_details=created_purchase_details[i % NUM_PURCHASE_DETAILS],
            serial_numbers=serial_numbers,
            properties=[Property.get(name=get_property_name(i % NUM_PROPERTIES))],
        ),
    )
