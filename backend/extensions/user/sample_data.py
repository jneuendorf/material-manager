from core.helpers.decorators import raised_from

from .models import Permission, Role, User
from .permissions import superuser, user_read, user_write

superuser_permission = Permission.get_or_create(**superuser)
user_read_permission = Permission.get_or_create(**user_read)
user_write_permission = Permission.get_or_create(**user_write)

superuser_role = Role.get_or_create(
    _related=dict(
        permissions=[
            superuser_permission,
            user_read_permission,
            user_write_permission,
        ],
    ),
    **superuser,
)
noop_role = Role.get_or_create(
    name="noop",
    description="May not do anything",
)

try:
    super_user: User = User.create_from_password(
        email="root@localhost.com",
        password="root",
        first_name="root",
        last_name="root",
        membership_number="1337",
        phone="+49 123 2397235",
        street="Wurzelstraße",
        house_number="1",
        city="Berlin",
        zip_code="13321",
        roles=[superuser_role],
    )
    super_user.update(is_active=True)
except raised_from(User.create_from_password):
    pass
try:
    oliver: User = User.create_from_password(
        email="oliver.wiese@fu-berlin.de",
        password="Mylar3-2pear-Alienate-latex-6jeff-6careless-Fanout-Eli",
        first_name="Oliver",
        last_name="Wiese",
        membership_number="FU-01",
        phone="+49 30 838 75291",
        street="Schwendenerstraße",
        house_number="1",
        city="Berlin",
        zip_code="14195",
        roles=[superuser_role],
    )
    oliver.update(is_active=True)
except raised_from(User.create_from_password):
    pass

try:
    noop_user: User = User.create_from_password(
        email="noop@localhost.com",
        password="noop",
        first_name="noop",
        last_name="noop",
        membership_number="0",
    )
    noop_user.update(is_active=True)
except raised_from(User.create_from_password):
    pass
