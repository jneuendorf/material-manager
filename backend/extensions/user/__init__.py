from core.helpers.extension import Extension

from . import models, resources

user = Extension(
    "user",
    __name__,
    models=(
        models.User,
        models.Role,
        models.Right,
        models.RoleRightMapping,
        models.UserRoleMapping,
    ),
    resources=(
        resources.User,
        resources.Users,
    ),
)
