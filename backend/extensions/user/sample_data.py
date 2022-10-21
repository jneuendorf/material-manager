from .models import Permission, Role, User
from .permissions import superuser, user_read, user_write

user_read_permission = Permission.get_or_create(**user_read)
user_write_permission = Permission.get_or_create(**user_write)

superuser_role = Role.get_or_create(
    _related=dict(
        permissions=[user_read_permission, user_write_permission],
    ),
    **superuser,
)
noop_role = Role.get_or_create(
    name="noop",
    description="May not do anything",
)

try:
    superuser = User.create_from_password(
        email="root@localhost.com",
        password="root",
        first_name="root",
        last_name="root",
        membership_number="1337",
        roles=[superuser_role],
    )
except User.create_from_password.__errors__:
    pass
try:
    noop_user = User.create_from_password(
        email="noop@localhost.com",
        password="noop",
        first_name="noop",
        last_name="noop",
        membership_number="0",
    )
except User.create_from_password.__errors__:
    pass
