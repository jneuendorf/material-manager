from flask_apispec import use_kwargs
from marshmallow import fields

from core.helpers.resource import ModelListResource, ModelResource
from core.helpers.schema import BaseSchema, ModelConverter

from . import models


class CommentSchema(BaseSchema):
    class Meta:
        model = models.Comment
        fields = (
            "id",
            "inspection_id",
            "material_id",
            "comment",
            # "photo",
        )


class Comment(ModelResource):
    url = "/comment"
    Schema = CommentSchema

    @use_kwargs(
        {
            "inspection_id": fields.Int(required=True),
            "material_id": fields.Int(required=True),
            "comment": fields.Str(required=True),
        }
    )
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


# Fetches all inspections
class Inspections(ModelListResource):
    url = "/inspections"
    Schema = InspectionSchema

    def get(self):
        inspections = models.Inspection.all()
        return self.serialize(inspections)
