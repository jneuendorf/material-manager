from backend.inspection.extension import InspectionExtension
from backend.material.extension import MaterialExtension
from backend.rental.extension import RentalExtension
from backend.user.extension import UserExtension

extension_classes = (
    MaterialExtension,
    UserExtension,
    InspectionExtension,
    RentalExtension,
)
