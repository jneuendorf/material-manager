from collections.abc import Callable, Mapping
from typing import Any, Generic, TypeVar

from blinker import ANY as ANY_SENDER
from blinker import NamedSignal

S = TypeVar("S")  # signal type
K = TypeVar("K", bound=Mapping[str, Any])  # kwargs type


class Signal(NamedSignal, Generic[S, K]):
    def connect(
        self,
        receiver: Callable[[S, K], Any],
        sender: S = ANY_SENDER,
        weak: bool = True,
    ):
        print("connecting to", self.name, "of", sender)
        return super().connect(receiver, sender, weak)

    def send(self, sender: S, **kwargs: Any):
        print("sending", self.name, "with", kwargs)
        return super().send(sender, data=kwargs)