from flask import abort
from flask_apispec import use_kwargs
from marshmallow import fields

from core.helpers.resource import ModelResource
from core.helpers.schema import BaseSchema
from extensions.legal import models


class BoardMemberSchema(BaseSchema):
    class Meta:
        model = models.BoardMember
        fields = ("member_first_name", "member_last_name", "position")


class ImprintSchema(BaseSchema):
    board_members = fields.List(fields.Nested(BoardMemberSchema()))

    class Meta:
        model = models.Imprint


class Imprint(ModelResource):
    url = "/imprint"

    Schema = ImprintSchema

    def get(self):
        imprints = models.Imprint.all()
        if not imprints:
            return abort(404, "No imprint data available")
        if len(imprints) > 1:
            return abort(403, "Multiple imprints found where one was expected")
        return self.serialize(imprints[0])

    @use_kwargs(ImprintSchema.to_dict(exclude=["id"]))
    def put(self, board_members: list[models.BoardMember], **kwargs):
        imprints: list[models.Imprint] = models.Imprint.all()
        if len(imprints) > 1:
            return abort(403, "Multiple imprints found where one was expected")

        imprint: models.Imprint
        if not imprints:
            imprint = models.Imprint.create(
                _related=dict(
                    board_members=board_members,
                ),
                **kwargs,
            )
        else:
            imprint = imprints[0]
            imprint.update(**kwargs)
        return self.serialize(imprint)
