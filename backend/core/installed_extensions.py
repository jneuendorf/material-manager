from backend.extensions.inspection import InspectionExtension
from backend.extensions.material import MaterialExtension
from backend.extensions.rental import RentalExtension
from backend.extensions.user import UserExtension

extensions = (
    MaterialExtension,
    UserExtension,
    InspectionExtension,
    RentalExtension,
)
