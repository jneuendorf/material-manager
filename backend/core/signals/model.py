from typing import Type, TypeVar

from core.helpers.orm import CrudModel
from core.signals.signal import Signal

M = TypeVar("M", bound=CrudModel)

ModelSignal = Signal[Type[M], M]

model_created = ModelSignal("model-created")
model_updated = ModelSignal("model-updated")
model_deleted = ModelSignal("model-deleted")
