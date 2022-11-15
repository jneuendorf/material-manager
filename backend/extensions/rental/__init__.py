from core.helpers.extension import Extension

from . import models
from .config import STATIC_FOLDER, STATIC_URL_PATH

rental = Extension(
    "rental",
    __name__,
    models=(
        models.Rental,
        models.RentalStatus,
        models.MaterialRentalMapping,
        models.ReturnInfo,
    ),
    resources=(),
)
