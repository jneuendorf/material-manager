from core.helpers.extension import Extension

from . import models, resources
from .config import STATIC_FOLDER, STATIC_URL_PATH

inspection = Extension(
    "inspection",
    __name__,
    static_url_path=STATIC_URL_PATH,
    static_folder=STATIC_FOLDER,
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
