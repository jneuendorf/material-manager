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
        imprint = models.Imprint.all()
        if imprint == []:
            abort(404, "No imprint data available")
        if len(imprint) > 1:
            abort(403, "Multiple imprints found where one was expected")
        return self.serialize(imprint[0])

    @use_kwargs(ImprintSchema.to_dict())
    def put(self, **kwargs):
        imprint = models.Imprint.all()
        if len(imprint) > 1:
            abort(403, "Multiple imprints found where one was expected")
        if imprint == []:
            member0 = models.BoardMember.get_or_create(
                member_first_name="(first name)",
                member_last_name="(last name)",
                position="(position)",
            )
            member1 = models.BoardMember.get_or_create(
                member_first_name="(first name)", member_last_name="(last name)"
            )
            imprint = models.Imprint.create(
                club_name="(club name)",
                street="(street name)",
                house_number="(house number)",
                city="(city name)",
                zip_code="(zip code)",
                phone="(phone number)",
                email="(email address)",
                registration_number=123456789,
                registry_court="(registry court name)",
                vat_number="(vat number)",
                dispute_resolution_uri="(dispute resolution uri)",
                _related=dict(board_members=[member0, member1]),
            )
        else:
            imprint = imprint[len(imprint) - 1]
        imprint.update(**kwargs)
        return self.serialize(imprint)
