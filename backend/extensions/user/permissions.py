"""Defines permission specific to this extension."""

# TODO: create instances on install

superuser = dict(
    name="superuser",
    description="May to anything",
)
"""This is a special permission that always allows access
when using the `permissions_required` decorator.
"""
user_read = dict(
    name="user:read",
    description="Allows reading any users data",
)
user_write = dict(
    name="user:write",
    description="Allows writing any users data",
)
