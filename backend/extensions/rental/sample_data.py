import itertools
from datetime import date, datetime, timedelta

from extensions.material.models import Material
from extensions.rental.models import Rental, RentalStatus

NUM_RENTAL = 50
NUM_USERS = 4

material_list = Material.all()
assert material_list, "Cannot create rentals because there are no materials"
materials = itertools.cycle(material_list)

for i in range(1, NUM_RENTAL + 1):
    if i % 50 == 0:
        rental_status = RentalStatus.RETURNED
    elif i % 40 == 0:
        rental_status = RentalStatus.UNAVAILABLE
    elif i % 30 == 0:
        rental_status = RentalStatus.LENT
    else:
        rental_status = RentalStatus.AVAILABLE

    Rental.get_or_create(
        customer_id=(i % NUM_USERS) + 1,
        lender_id=i,
        rental_status=rental_status,
        cost=i % 100 + (i % 100) * 0.01,
        discount=int(i % 100),
        deposit=3 * (i % 100) + (i % 100) * 0.01,
        created_at=datetime(2022, 1, 1) + timedelta(days=i),
        start_date=date(2022, 1, 1) + timedelta(days=i + 7),
        end_date=date(2022, 1, 1) + timedelta(days=i + 14),
        usage_start_date=None,
        usage_end_date=None,
        return_to_id=i,
        _related=dict(materials=[next(materials), next(materials)]),
    )
