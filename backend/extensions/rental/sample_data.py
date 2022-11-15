from datetime import date, timedelta

from extensions.rental.models import Rental, RentalStatus

NUM_Rental = 50

for i in range(NUM_Rental):
    if i % 50 == 0:
        rentalStatus = RentalStatus.RETURNED
    elif i % 40 == 0:
        rentalStatus = RentalStatus.UNAVAILABLE
    elif i % 30 == 0:
        rentalStatus = RentalStatus.LENT
    else:
        rentalStatus = RentalStatus.AVAILABLE
    Rental.get_or_create(
        customer_id=i,
        lender_id=i,
        rental_status=rentalStatus,
        cost=float(i % 100) + float((i % 100) * 0.01),
        discount=int(i % 100),
        deposit=3 * (float(i % 100) + float((i % 100) * 0.01)),
        created_at=date(2022, 1, 1) + timedelta(days=i),
        start_date=date(2022, 1, 1) + timedelta(days=i + 7),
        end_date=date(2022, 1, 1) + timedelta(days=i + 14),
        usage_start_date=None,
        usage_end_date=None,
        return_to_id=i,
    )
