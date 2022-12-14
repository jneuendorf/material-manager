import itertools as it
from datetime import date, timedelta
from hashlib import sha1

from extensions.common.models import File
from extensions.material.models import (
    Condition,
    InventoryNumber,
    Material,
    MaterialSet,
    MaterialType,
    Property,
    PropertyType,
    PurchaseDetails,
    SerialNumber,
)

NUM_PROPERTIES = 18
NUM_PURCHASE_DETAILS = 30
NUM_MATERIALS = 50

INVENTORY_IDENTIFIERS = it.cycle(["J", "K", "L", "G"])
MERCHANTS = it.cycle(["InterSport", "Globetrotter", "SecondHand", "Amazon"])
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

# Create property types
property_types: dict[str, PropertyType] = {
    "color": PropertyType.get_or_create(
        name="color",
        description="color",
        unit="color",
    ),
    "thickness": PropertyType.get_or_create(
        name="thickness",
        description="thickness",
        unit="mm",
    ),
    "length": PropertyType.get_or_create(
        name="length",
        description="length",
        unit="m",
    ),
    "size": PropertyType.get_or_create(
        name="size",
        description="size",
        unit="",
    ),
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
                property_types=[
                    property_types["color"],
                    property_types["size"],
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
                property_types=[
                    property_types["color"],
                    property_types["length"],
                    property_types["thickness"],
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
                property_types=[
                    property_types["color"],
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

# Create material images
material_images: dict[str, File] = {
    "carabiner": (
        File.get_or_create(
            related_extension="material",
            path="carabiner.jpg",
            mime_type="image/jpeg",
            description="silver carabiner",
        ).download(
            url="https://drive.google.com/file/d/160psfXfn0xv-4WjkSbDuaNiJMqe4EAGg/view?usp=share_link",  # noqa
            resize=(800, 600),
        )
    ),
    "express_sling": (
        File.get_or_create(
            related_extension="material",
            path="express_sling.jpg",
            mime_type="image/jpeg",
            description="black/silver express sling",
        ).download(
            url="https://drive.google.com/file/d/1j4gkg4tqGD3BTyLBL6OVY-CoUA2tOVtl/view?usp=sharing",  # noqa
            resize=(800, 600),
        )
    ),
    "harness": (
        File.get_or_create(
            related_extension="material",
            path="harness.jpg",
            mime_type="image/jpeg",
            description="red/black harness",
        ).download(
            url="https://drive.google.com/file/d/1K_MQ3KSqdIFa-MgyciwYMV--DEjzOhxe/view?usp=sharing",  # noqa
            resize=(800, 600),
        )
    ),
    "rope": (
        File.get_or_create(
            related_extension="material",
            path="rope.jpg",
            mime_type="image/jpeg",
            description="lime green rope",
        ).download(
            url="https://drive.google.com/file/d/1yKwMOxKo6jcjoftc4XdRzPb8R8t2ScN2/view?usp=sharing",  # noqa
            resize=(800, 600),
        )
    ),
    # "ribbon": (
    #     File.get_or_create(
    #         related_extension="material",
    #         path="ribbon.jpg",
    #         mime_type="image/jpeg",
    #         description="blue ribbon",
    #     ).download(
    #         url="https://drive.google.com/file/d/11fQQz9vC2j4f9vooQSU55BaoAxHdGRI3/view?usp=sharing",  # noqa
    #         resize=(800, 600),
    #     )
    # ),
}


# Create materials


def create_serial_and_inventory_number(
    index: int,
) -> tuple[SerialNumber, InventoryNumber]:
    return (
        SerialNumber.get_or_create(
            serial_number=(
                f"sn-{index}-{sha1(str(index).encode('utf-8')).hexdigest()[:10]}"
            ),
            production_date=date(2022, 1, 1) + timedelta(days=index),
            manufacturer=next(MANUFACTURERS),
        ),
        InventoryNumber.get_or_create(
            inventory_number=f"{next(INVENTORY_IDENTIFIERS)}-{index}",
        ),
    )


for i in range(NUM_MATERIALS):
    # create mostly ok condition, some repair, rarely broken for Material.condition
    if i % 50 == 0:
        condition = Condition.BROKEN
    elif i % 20 == 0:
        condition = Condition.REPAIR
    else:
        condition = Condition.OK

    serial_numbers: list[SerialNumber]
    inventory_numbers: list[InventoryNumber]
    if i < NUM_MATERIALS / 2:
        serial_number, inventory_number = create_serial_and_inventory_number(i)
        serial_numbers = [serial_number]
        inventory_numbers = [inventory_number]
    # Let some materials have multiple serial/inventory numbers
    else:
        serial_number, inventory_number = create_serial_and_inventory_number(i)
        # Make sure we don't create the same numbers twice
        serial_number2, inventory_number2 = create_serial_and_inventory_number(
            i + NUM_MATERIALS
        )
        serial_numbers = [serial_number, serial_number2]
        inventory_numbers = [inventory_number, inventory_number2]

    installation_date = date(2022, 1, 1) + timedelta(days=i)
    material_type: MaterialType = next(material_types)
    material = Material.get_or_create(
        name=f"material {i+1}",
        installation_date=installation_date,
        max_operating_date=installation_date + timedelta(weeks=(-1) ** i * 2),
        max_days_used=i % 5 + 1,
        instructions="some instructions...",
        next_inspection_date=installation_date + timedelta(weeks=(-1) ** i),
        rental_fee=1.13 * (i + 1),
        condition=condition,
        days_used=i * 5 % 100,
        _related=dict(
            material_type=material_type,
            purchase_details=created_purchase_details[i % NUM_PURCHASE_DETAILS],
            serial_numbers=serial_numbers,
            inventory_numbers=inventory_numbers,
            properties=[
                Property.get_or_create(
                    value=str(i),
                    _related=dict(
                        property_type=property_type,
                    ),
                )
                for property_type in material_type.property_types
            ],
            images=(
                [material_images[material_type.name]]
                if material_type.name in material_images
                else []
            ),
        ),
    )
