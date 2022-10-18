from core.helpers.extension import Extension
from core.signals import model_created

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


def receiver(sender, data):
    print("user instance created:", sender, data)


model_created.connect(
    receiver,
    sender=models.User,
)
