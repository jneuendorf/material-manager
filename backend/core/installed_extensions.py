from backend.extensions.inspection import InspectionExtension
from backend.extensions.material import MaterialExtension
from backend.extensions.rental.extension import RentalExtension
from backend.extensions.user.extension import UserExtension

extension_classes = (
    MaterialExtension,
    UserExtension,
    InspectionExtension,
    RentalExtension,
)
