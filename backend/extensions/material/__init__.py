from core.helpers.extension import Extension

from . import models, resources

material = Extension(
    "material",
    __name__,
    static_url_path="/material/static",
    static_folder="static",
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
