from functools import wraps

from flask import abort, current_app
from flask_jwt_extended import current_user, jwt_required

from .models import User
from .permissions import superuser

session_required = jwt_required()
"""This decorator should be used for checking if a user is currently logged in
because it's agnostic of the auth implementation.
"""


def permissions_required(*required_permissions: str):
    def decorator(fn):
        @wraps(fn)
        @jwt_required()
        def wrapper(*args, **kwargs):
            user: "User" = current_user
            user_permissions = set(permission.name for permission in user.permissions)
            if current_app.debug:
                # TODO: use logging
                print("Checking permissions...")
                print("> required:", required_permissions)
                print("> given:", user_permissions)
            if (
                superuser["name"] in user_permissions
                or set(required_permissions) - user_permissions
            ):
                return abort(403, "Permission denied")
            return fn(*args, **kwargs)

        return wrapper

    return decorator
