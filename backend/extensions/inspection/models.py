import enum
from typing import Type

from sqlalchemy import UniqueConstraint

from core.extensions import db
from core.helpers.orm import CrudModel
from extensions.common.models import File

Model: Type[CrudModel] = db.Model


class InspectionType(enum.Enum):
    NORMAL = "NORMAL"  # Sichtprüfung
    PSA = "PSA"


def resolve_user_model():
    """Resolve user model lazily. See:
    https://docs.sqlalchemy.org/en/14/orm/basic_relationships.html#late-evaluation-of-relationship-arguments
    """  # noqa
    from extensions.user.models import User

    return User


def resolve_material_model():
    """Resolve material model lazily. See:
    https://docs.sqlalchemy.org/en/14/orm/basic_relationships.html#late-evaluation-of-relationship-arguments
    """  # noqa
    from extensions.material.models import Material

    return Material


class Inspection(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    date = db.Column(db.Date)
    type = db.Column(
        db.Enum(InspectionType, create_constraint=True),
        nullable=False,
        default=InspectionType.NORMAL,
    )
    # many to one (FK here)
    inspector_id = db.Column(db.ForeignKey("user.id"))
    inspector = db.relationship(resolve_user_model, backref="inspections")
    # one to many (FK on child)
    comments = db.relationship("Comment", backref="inspection")


class Comment(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    comment = db.Column(db.Text)
    inspection_id = db.Column(db.ForeignKey(Inspection.id))
    # many to one (FK here)
    material_id = db.Column(db.ForeignKey("material.id"))
    material = db.relationship(resolve_material_model, backref="comments")
    # one to one
    image_id = db.Column(db.ForeignKey(File.id))
    image = db.relationship("File", uselist=False)

    __table_args__ = (
        UniqueConstraint("inspection_id", "material_id", name="inspection_material_uc"),
    )
