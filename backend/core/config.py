from datetime import timedelta

from apispec import APISpec
from apispec.ext.marshmallow import MarshmallowPlugin

flask_config = {
    # configure the SQLite database, relative to the app instance folder
    "SQLALCHEMY_DATABASE_URI": "sqlite:///material_manager.db",
    # TODO: change when in running in production mode
    "JWT_SECRET_KEY": "eyJmcmVzaCI6ZmFs",
    "JWT_ACCESS_TOKEN_EXPIRES": timedelta(hours=5),
    "JWT_REFRESH_TOKEN_EXPIRES": timedelta(days=5),
    "JWT_TOKEN_LOCATION": "headers",
    "APISPEC_SPEC": APISpec(
        title="Material Manager",
        version="v1",
        plugins=[MarshmallowPlugin()],
        openapi_version="2.0.0",
    ),
    # "APISPEC_SWAGGER_URL": "/swagger/",  # URI to access API Doc JSON
    "APISPEC_SWAGGER_UI_URL": "/",  # URI to access UI of API Doc
    "MAIL_SERVER": "smtp.freesmtpservers.com",
    "MAIL_PORT": 25,
    "MAIL_DEFAULT_SENDER": ("Material Manager", "noreply@material-manager.org"),
    # List of module paths to installed extensions.
    "CORE_INSTALLED_EXTENSIONS": [
        "material",
        "user",
        "inspection",
        "rental",
    ],
    "CORE_PUBLIC_API_URL": "http://localhost:5000",  # port backend/Makefile
    "CORE_PUBLIC_FRONTEND_URL": "http://localhost:55542",  # port frontend/Makefile
}
