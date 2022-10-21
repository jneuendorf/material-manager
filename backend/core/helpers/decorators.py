from functools import wraps
from typing import Any, Collection, Protocol, Type, cast


class ThrowingCallable(Protocol):
    __errors__: Collection[Type[Exception]]

    def __call__(self, *args, **kwargs) -> Any:
        ...


def raises(*errors: Type[Exception]):
    def decorator(fn) -> ThrowingCallable:
        @wraps(fn)
        def wrapper(*args, **kwargs):
            return fn(*args, **kwargs)

        wrapper = cast(ThrowingCallable, wrapper)
        wrapper.__errors__ = tuple(set(errors))
        return wrapper

    return decorator
