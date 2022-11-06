import datetime
import random

from extensions.material.models import (  # Property,
    Material,
    MaterialType,
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
    i = 0
    inventory_identifier = ["J", "K", "L", "G"]
    conditions = ["ok", "inspection", None]
    merchants = ["InterSport", "Globetrotter", "SecondHand", "Amazon"]

    for row in data_sheet:

        # generate random number between

        # give the file the selected Image
        Materialnum = random.randint(6, 27)
        Materialimg = "Images/Material" + str(Materialnum) + ".jpg"

        rand_price = round(random.uniform(0.01, 99.99), 2)
        rand_price1 = round(random.uniform(0.01, 99.99), 2)
        rand_int0 = random.randint(0, 99)
        rand_int1 = random.randint(0, 99)
        rand_int2 = str(random.randint(0, 9999))
        rand_equipment_id = random.randint(0, 16)
        rand_inventory_num = random.sample(inventory_identifier, k=2)
        rand_inventory_num = (
            rand_inventory_num[0] + rand_inventory_num[1] + str(rand_int1)
        )

        MaterialType.get_or_create(
            name=str(row[3]),
            # description=,
        )

        Material.create(
            equipment_type_id=rand_equipment_id,
            inventory_number=rand_inventory_num,
            max_life_expectancy=row[12],
            max_service_duration=row[13],
            installation_date=rand_date(2014, 1, 1, 2022, 9, 1),
            instructions=None,
            next_inspection_date=rand_date(2022, 9, 1, 2023, 6, 1),
            rental_fee=rand_price,
            condition=random.choice(conditions),
            days_used=rand_int0,
            image=Materialimg,
        )

        SerialNumber.create(
            material_id=i + 1,
            serial_number=str(row[11]),
            production_date=rand_date(2014, 1, 1, 2022, 1, 1),
            manufacturer=str(row[5]),
        )

        PurchaseDetails.create(
            material_id=i + 1,
            purchase_date=rand_date(2014, 1, 1, 2022, 9, 1),
            invoice_number=rand_int2,
            merchant=random.choice(merchants),
            purchase_price=rand_price1,
            suggested_retail_price=rand_price1,
        )

        i += 1
