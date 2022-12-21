from core.helpers.extension import Extension

from . import models, resources

legal = Extension(
    "legal",
    __name__,
    models=(models.Imprint, models.BoardMember, models.PrivacyPolicy),
    resources=(resources.Imprint, resources.PrivacyPolicy),
)
