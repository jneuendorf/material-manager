from flask_restful import Resource

from dav_core.resources.user import UserResource

routes: dict[tuple[str, ...], Resource] = {
    ("/users",): UserResource,
}
