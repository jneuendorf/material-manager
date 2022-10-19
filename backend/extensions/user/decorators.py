from functools import wraps
from typing import TYPE_CHECKING

from flask import abort
from flask_jwt_extended import current_user, jwt_required

if TYPE_CHECKING:
    from .models import User


def rights_required(*required_rights: str):
    def decorator(fn):
        @wraps(fn)
        @jwt_required()
        def wrapper(*args, **kwargs):
            print("CHECKING PERMISSIONS")
            user: "User" = current_user
            user_rights = set(right.name for right in user.rights)
            print("required:", required_rights)
            print("given:", user_rights)
            if set(required_rights) - user_rights:
                abort(401, "Permission denied")
            return fn(*args, **kwargs)

        return wrapper

    return decorator
