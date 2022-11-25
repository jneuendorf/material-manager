from core.helpers.extension import Extension

from . import models, resources

rental = Extension(
    "rental",
    __name__,
    template_folder="templates",
    models=(
        models.Rental,
        models.RentalStatus,
        models.MaterialRentalMapping,
    ),
    resources=(resources.RentalConfirmation,),
)
