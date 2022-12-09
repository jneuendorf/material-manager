from flask_apispec import use_kwargs
from marshmallow import fields

from core.helpers.resource import ModelResource
from core.helpers.schema import BaseSchema, ModelConverter

from . import models


class BoardMemberSchema(BaseSchema):
    class Meta:
        model = models.BoardMember
        fields = ("member_first_name", "member_last_name", "position")


class ImprintSchema(BaseSchema):
    board_members = fields.List(fields.Nested(BoardMemberSchema()))

    class Meta:
        model_converter = ModelConverter
        model = models.Imprint


class PrivacyPolicySchema(BaseSchema):
    class Meta:
        model_converter = ModelConverter
        model = models.PrivacyPolicy


class Imprint(ModelResource):
    url = "/imprint"

    Schema = ImprintSchema

    def get(self):
        imprint = models.Imprint.get(id=1)
        return self.serialize(imprint)

    @use_kwargs(ImprintSchema.to_dict(exclude=["id"]))
    def put(self, **kwargs):
        imprint = models.Imprint.get(id=1)
        models.Imprint.update(imprint, **kwargs)
        return self.serialize(imprint)


class PrivacyPolicy(ModelResource):
    url = "/privacy_policy"

    Schema = PrivacyPolicySchema

    def get(self):
        privacy_policy = models.PrivacyPolicy.get(id=1)
        return self.serialize(privacy_policy)

    @use_kwargs(PrivacyPolicySchema.to_dict(exclude=["id"]))
    def put(self, **kwargs):
        privacy_policy = models.PrivacyPolicy.get(id=1)
        models.PrivacyPolicy.update(privacy_policy, **kwargs)
        return self.serialize(privacy_policy)
