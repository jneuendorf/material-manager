from core.helpers.extension import Extension

from . import models, resources

material = Extension(
    "material",
    __name__,
    models=(
        models.Material,
        models.SerialNumber,
        models.PurchaseDetails,
        models.EquipmentType,
        models.Property,
        models.MaterialPropertyMapping,
    ),
    resources=(
        resources.Material,
        resources.Materials,
    ),
)
