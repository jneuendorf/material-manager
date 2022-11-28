from core.helpers.extension import Extension

from . import models, resources

rental = Extension(
    "rental",
    __name__,
    models=(
        models.Rental,
        # models.RentalStatus,
        models.MaterialRentalMapping,
    ),
    resources=(
        resources.Rental,
        resources.Rentals,
        resources.RentalStatus,
    ),
)
