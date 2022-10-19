from typing import Type, TypedDict

from core.helpers.orm import CrudModel
from core.signals.signal import Signal

Sender = Type[CrudModel]


class Kwargs(TypedDict):
    instance: CrudModel


class ModelSignal(Signal[Sender, Kwargs]):
    ...


model_created = ModelSignal("model-created")
model_updated = ModelSignal("model-updated")
model_deleted = ModelSignal("model-deleted")
