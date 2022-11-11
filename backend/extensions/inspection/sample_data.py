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
        "https://www.anschlagmittel-shop.de/media/catalog/product/cache/"
        "e4e7b33686f42ecc97289255410c8bc4/f/a/fa5010522b.png"
    ),
    description="carabiner green",
    mime_type="image/png",
    _related=dict(
        object=comment1,
    ),
)
print(comment1.photo.path)
icon = File.get_or_create(
    path="icon.png",
    description="material manager icon",
    mime_type="image/png",
    _related=dict(
        object=ok_material,
    ),
)
print(ok_material.images[0].path)
# icon.delete()
# print(ok_material.images)
