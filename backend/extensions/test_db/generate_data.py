import datetime
import random

from extensions.material.models import (
    Condition,
    Material,
    MaterialSet,
    MaterialType,
    Property,
    PurchaseDetails,
    SerialNumber,
)


def rand_date(start_yyyy, start_mm, start_dd, end_yyyy, end_mm, end_dd):
    start_dt = datetime.date(start_yyyy, start_mm, start_dd)
    end_dt = datetime.date(end_yyyy, end_mm, end_dd)
    time_between_dates = end_dt - start_dt
    days_between_dates = time_between_dates.days
    random_number_of_days = random.randrange(days_between_dates)
    random_date = start_dt + datetime.timedelta(days=random_number_of_days)
    return random_date


def test_data(data_sheet):
    i = 1
    inventory_identifier = ["J", "K", "L", "G"]
    merchants = ["InterSport", "Globetrotter", "SecondHand", "Amazon"]
    units = ["g", "kg", "meter", "cm"]
    set_names = ["bergtour", "eiswand", "wandern", "zelten"]
    material_types = ["gold", "silber", "bronze", "holz"]

    pro_ID = Property.create(
        id=1,
        name="TODO",
        description="hier sollte eine Beschreibung stehen",
        value=random.randint(0, 99),
        unit=random.choice(units),
    )

    for j in material_types:
        mat_ID = MaterialType.create(
            id=material_types.index(j),
            name=j,
            description="shiny",
            _related=dict(
                # sets=
            ),
        )

    for j in set_names:
        MaterialSet.create(id=set_names.index(j), set_name=j)

    for row in data_sheet:

        rand_inventory_num = random.sample(inventory_identifier, k=2)
        rand_inventory_num = (
            rand_inventory_num[0] + rand_inventory_num[1] + str(random.randint(0, 99))
        )

        if i % 50 == 0:
            rand_condition = Condition.BROKEN
        elif i % 20 == 0:
            rand_condition = Condition.REPAIR
        else:
            rand_condition = Condition.OK

        ser_ID = SerialNumber.get_or_create(
            id=i,
            serial_number=i,
            production_date=rand_date(2014, 1, 1, 2022, 1, 1),
            manufacturer=str(row[5]),
            material_id=i,
        )

        pur_ID = PurchaseDetails.create(
            id=i,
            purchase_date=rand_date(2014, 1, 1, 2022, 9, 1),
            invoice_number=random.choice(inventory_identifier) + str(i * 5),
            merchant=random.choice(merchants),
            purchase_price=round(random.uniform(0.01, 99.99), 2),
            suggested_retail_price=round(random.uniform(0.01, 99.99), 2),
        )

        Material.create(
            id=i,
            inventory_number=rand_inventory_num,
            max_life_expectancy=row[12],
            max_service_duration=row[13],
            installation_date=rand_date(2014, 1, 1, 2022, 9, 1),
            instructions="Drei Knoten ohne Hände im Kopfstand",
            next_inspection_date=rand_date(2022, 9, 1, 2023, 6, 1),
            rental_fee=round(random.uniform(0.01, 99.99), 2),
            condition=rand_condition,
            days_used=random.randint(0, 99),
            # many to one (FK here)
            # material_type_id = db.Column(db.ForeignKey(MaterialType.id))
            # many to one (FK here)
            purchase_details_id=i,
            _related=dict(
                material_type=mat_ID,
                purchase_details=pur_ID,
                serial_numbers=[ser_ID],
                properties=[pro_ID],
            ),
        )

        i += 1
