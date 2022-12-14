from flask_apispec import use_kwargs
from marshmallow import fields

from core.helpers.extension import url_join
from core.helpers.resource import ModelListResource, ModelResource
from core.helpers.schema import BaseSchema, ModelConverter
from extensions.common.decorators import FileSchema, with_file

from . import models
from .config import STATIC_URL_PATH


class CommentSchema(BaseSchema):
    image_url = fields.Method("get_image_urls")

    class Meta:
        model = models.Comment
        fields = (
            "id",
            "inspection_id",
            "material_id",
            "comment",
            "image_id",
            "image_url",
        )
        # dump_only = ("image_url",)

    def get_image_urls(self, obj: models.Comment):
        image = obj.image
        return url_join(STATIC_URL_PATH, image.path)


class Comment(ModelResource):
    url = "/comment"
    Schema = CommentSchema

    @use_kwargs(
        {
            "inspection_id": fields.Int(required=True),
            "material_id": fields.Int(required=True),
            "image": fields.Nested(FileSchema()),
            "comment": fields.Str(required=True),
        }
    )
    @with_file("image", related_extension="inspection")
    def post(self, **kwargs) -> dict:
        """Test with
        curl -X POST "http://localhost:5000/comment" \
        -H 'Content-Type: application/json' \
        -d '{"inspection_id":"0", "material_id":"0",
        "comment":"Comment about the material status"}'
        """
        comment = models.Comment.create(**kwargs)
        return self.serialize(comment)


# I thought we should return all comments by material_id,
# but Do we need Inspection attributes like date?
class Comments(ModelListResource):
    url = "/comments/<int:material_id>"
    Schema = CommentSchema

    def get(self, material_id):
        comments = models.Comment.filter(material_id=material_id)
        return self.serialize(comments)


class InspectionSchema(BaseSchema):
    class Meta:
        # TODO: specifying model_converter should not be necessary
        #  Check why the metaclass doesn't work
        model_converter = ModelConverter
        model = models.Inspection
        fields = ("inspector_id", "date")


class Inspection(ModelResource):
    url = [
        "/inspection",
        "/inspection/<int:inspection_id>",
    ]
    Schema = InspectionSchema

    def get(self, inspection_id: int):
        inspection = models.Inspection.get(id=inspection_id)
        return self.serialize(inspection)

    @use_kwargs(
        {"inspector_id": fields.Int(required=True), "date": fields.Date(required=True)}
    )
    def post(self, **kwargs) -> dict:
        inspection = models.Inspection.create(**kwargs)
        return self.serialize(inspection)
