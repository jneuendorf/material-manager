from flask_jwt_extended import JWTManager

from .models import User


def init_auth(jwt: JWTManager):
    @jwt.user_identity_loader
    def user_identity_lookup(user: User):
        return user.id

    @jwt.user_lookup_loader
    def user_lookup_callback(_jwt_header, jwt_data):
        identity = jwt_data["sub"]
        return User.get_or_none(id=identity)

    # @app.route("/login", methods=["POST"])
    # def login():
    #     """
    #     curl -X POST 'http://localhost:5000/login' -H 'Content-Type: application/json'
    #       -d '{"email":"root@localhost.com","password":"asdf"}'
    #     """  # noqa
    #     email = request.json.get("email", None)
    #     password = request.json.get("password", None)
    #     user = User.get_or_none(email=email)
    #     if not user or not user.verify_password(password):
    #         return jsonify("Wrong email or password"), 401
    #
    #     access_token = create_access_token(identity=user)
    #     return jsonify(access_token=access_token)
