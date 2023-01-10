from datetime import date
from pathlib import Path

from extensions.common.models import File
from extensions.material.models import Material
from extensions.user.models import Role, User

from ..models import Comment, Inspection

material: Material = Material.all()[0]

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
        material=material,
        image=File.get_or_create_from_base64(
            related_extension="inspection",
            data=(Path(__file__).parent / "broken-carabiner.jpg").read_bytes(),
            description="broken carabiner",
            mime_type="image/jpeg",
        ),
    ),
)
print(comment1.image.path)
