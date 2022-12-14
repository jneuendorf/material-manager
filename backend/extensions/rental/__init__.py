from core.helpers.extension import Extension

from . import models, resources

rental = Extension(
    "rental",
    __name__,
    static_url_path="/rental/static",
    static_folder="static",
    template_folder="templates",
    models=(
        models.Rental,
        models.MaterialRentalMapping,
    ),
    resources=(
        resources.Rental,
        resources.Rentals,
        resources.RentalConfirmationPdf,
        resources.RentalConfirmationHtml,
    ),
)
