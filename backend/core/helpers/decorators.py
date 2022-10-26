from collections.abc import Callable, Collection
from functools import wraps
from typing import Any, Protocol, Type, cast


class ThrowingCallable(Protocol):
    __errors__: Collection[Type[Exception]]

    def __call__(self, *args, **kwargs) -> Any:
        ...


def raises(*errors: Type[Exception]):
    """Annotates the wrapped function with error types that can be raised by that
    function. To use these error types for catching use the `raised_from` function
    below.
    """

    def decorator(fn) -> ThrowingCallable:
        @wraps(fn)
        def wrapper(*args, **kwargs):
            return fn(*args, **kwargs)

        wrapper = cast(ThrowingCallable, wrapper)
        wrapper.__errors__ = tuple(set(errors))
        return wrapper

    return decorator


def raised_from(func: Callable) -> Collection[Type[Exception]]:
    """Returns the error types annotated with the `@raises` decorator."""
    return getattr(func, "__errors__", ())
