from typing import Type

from core.extension import Extension
from inspection.extension import InspectionExtension
from material.extension import MaterialExtension
from user.extension import UserExtension

extension_classes: list[Type[Extension]] = [
    MaterialExtension,
    UserExtension,
    InspectionExtension,
]
