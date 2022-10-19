from core.helpers.extension import Extension

from . import models

inspection = Extension(
    "inspection",
    __name__,
    models=(
        models.Inspection,
        models.Comment,
    ),
    resources=(),
)
