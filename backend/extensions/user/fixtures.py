from .models import Right, Role, User

user_read_right = Right.get_or_create(
    name="user:read",
    description="Allows reading any users data",
)
user_write_right = Right.get_or_create(
    name="user:write",
    description="Allows writing any users data",
)

superuser_role = Role.get_or_create(
    name="superuser",
    description="May do anything",
    _related=dict(
        rights=[user_read_right, user_write_right],
    ),
)

user = User.get_or_create(
    email="root@localhost.com",
    first_name="super",
    last_name="user",
    membership_number="1337",
    _related=dict(
        roles=[superuser_role],
    ),
)
