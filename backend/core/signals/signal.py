from collections.abc import Callable
from typing import Any, Generic, TypeVar

from blinker import ANY as ANY_SENDER
from blinker import NamedSignal

SENDER = TypeVar("SENDER")
DATA = TypeVar("DATA")


class Signal(NamedSignal, Generic[SENDER, DATA]):
    def connect(
        self,
        receiver: Callable[[SENDER, DATA], Any],
        sender: SENDER = ANY_SENDER,
        weak: bool = True,
    ):
        print("connecting to", self.name, "of", sender)
        return super().connect(receiver, sender, weak)

    def send(self, sender: SENDER, data: DATA):
        print("sending", self.name, "with", data)
        return super().send(sender, data=data)
