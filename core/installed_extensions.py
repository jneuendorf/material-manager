from typing import Type

from core.extension import Extension
from material.extension import MaterialExtension

extension_classes: list[Type[Extension]] = [
    MaterialExtension,
]
