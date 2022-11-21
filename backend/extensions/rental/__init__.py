from core.helpers.extension import Extension

from . import models

rental = Extension(
    "rental",
    __name__,
    models=(
        models.Rental,
        models.RentalStatus,
        models.MaterialRentalMapping,
    ),
    resources=(),
)
