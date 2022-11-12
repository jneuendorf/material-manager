from core.helpers.extension import Extension

from . import models, resources
from .config import STATIC_FOLDER, STATIC_URL_PATH

material = Extension(
    "material",
    __name__,
    static_url_path=STATIC_URL_PATH,
    static_folder=STATIC_FOLDER,
    models=(
        models.MaterialType,
        models.Material,
        models.SerialNumber,
        models.PurchaseDetails,
        models.MaterialSet,
        models.MaterialTypeSetMapping,
        models.Property,
        models.MaterialPropertyMapping,
    ),
    resources=(
        resources.Material,
        resources.Materials,
        resources.MaterialType,
        resources.MaterialTypes,
    ),
)
