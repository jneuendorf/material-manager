from core.helpers.extension import Extension

from . import models, resources

inspection = Extension(
    "inspection",
    __name__,
    models=(
        models.Inspection,
        models.Comment,
    ),
    resources=(
        resources.Inspection,
        resources.Comment,
        resources.Comments,
    ),
)
