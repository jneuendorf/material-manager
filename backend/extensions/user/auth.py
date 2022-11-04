from flask_jwt_extended import JWTManager
from password_strength import PasswordPolicy

from .models import User

# Strong passwords start at 0.66.
# See https://github.com/kolypto/py-password-strength#complexity
password_policy = PasswordPolicy.from_names(
    length=8,  # min length: 8
    nonletters=2,  # need min. 2 non-letter characters (digits, specials, anything)
    strength=0.4,
)


def init_auth(jwt: JWTManager):
    @jwt.user_identity_loader
    def user_identity_lookup(user: User):
        return user.id

    @jwt.user_lookup_loader
    def user_lookup_callback(_jwt_header, jwt_data):
        identity = jwt_data["sub"]
        return User.get_or_none(id=identity)
