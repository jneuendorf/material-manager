from flask import Flask
from flask_restful import Api

from dav_core.routes import routes

app = Flask(__name__)
api = Api(app)

for urls, resource in routes.items():
    api.add_resource(resource, *urls)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"
