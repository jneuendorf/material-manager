from datetime import date

from extensions.common.models import File
from extensions.material.models import Material, SerialNumber
from extensions.user.models import Role, User

from .models import Comment, Inspection

inspector_role = Role.get_or_create(
    name="PSA inspector",
    description="May inspect anything",
)
inspector = User.get_or_none(email="inspector@localhost.com")
if inspector is None:
    inspector = User.create_from_password(
        email="inspector@localhost.com",
        password="inspector",
        first_name="inspector",
        last_name="inspector",
        membership_number="12345",
        roles=[inspector_role],
    )
    inspector.update(is_active=True)

ok_material = Material.get_or_create(
    inventory_number="m_ok",
    _related=dict(
        serial_numbers=[
            SerialNumber.get_or_create(
                serial_number="asdfjsdf9sdf",
            ),
        ],
    ),
)
inspection = Inspection.get_or_create(
    date=date(2020, 1, 1),
    type="PSA",
    _related=dict(
        inspector=inspector,
    ),
)
comment1 = Comment.get_or_create(
    comment="comment 1",
    _related=dict(
        inspection=inspection,
        material=ok_material,
    ),
)
File.get_or_create(
    path=(
        "https://pixabay.com/get/g7dffc9f8a6fea84f6c367735ecf96db26d3671fb4a822"
        "904e2edc0568e7142f87730c93f9c2ca7776afd254cee900cbac67d3e4dce431c4292a4"
        "607bae9a2aa6c4f86e84f0b7bc917daebc8dc7b5bed2_640.jpg"
    ),
    filename="karabiner.jpg",
    mime_type="image/jpeg",
    _related=dict(
        object=comment1,
    ),
)
print(comment1.photo.path)
