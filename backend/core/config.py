from apispec import APISpec
from apispec.ext.marshmallow import MarshmallowPlugin

flask_config = {
    # configure the SQLite database, relative to the app instance folder
    "SQLALCHEMY_DATABASE_URI": "sqlite:///test.db",
    "APISPEC_SPEC": APISpec(
        title="Material Manager",
        version="v1",
        plugins=[MarshmallowPlugin()],
        openapi_version="2.0.0",
    ),
    "APISPEC_SWAGGER_URL": "/swagger/",  # URI to access API Doc JSON
    "APISPEC_SWAGGER_UI_URL": "/swagger-ui/",  # URI to access UI of API Doc
    # List of module paths to installed extensions.
    "INSTALLED_EXTENSIONS": [
        "material",
        "user",
        "inspection",
        "rental",
    ],
}
