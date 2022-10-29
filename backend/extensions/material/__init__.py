from core.helpers.extension import Extension

from . import models, resources

material = Extension(
    "material",
    __name__,
    models=(
        models.EquipmentType,
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
        resources.EquipmentType,
        resources.EquipmentTypes,
    ),
)
