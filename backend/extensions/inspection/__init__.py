from core.helpers.extension import Extension

from . import models, resources

inspection = Extension(
    "inspection",
    __name__,
    static_url_path="/inspection/static",
    static_folder="static",
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
