from flask import abort
from flask_apispec import use_kwargs

from core.helpers.resource import ModelResource
from core.helpers.schema import BaseSchema
from extensions.legal import models


class PrivacyPolicySchema(BaseSchema):
    class Meta:
        model = models.PrivacyPolicy


class PrivacyPolicy(ModelResource):
    url = "/privacy_policy"
    Schema = PrivacyPolicySchema

    def get(self):
        privacy_policies = models.PrivacyPolicy.all()
        if not privacy_policies:
            return abort(404, "No privacy_policy data available")
        if len(privacy_policies) > 1:
            return abort(403, "Multiple privacy_policy found where one was expected")
        return self.serialize(privacy_policies[0])

    @use_kwargs(PrivacyPolicySchema.to_dict())
    def put(self, **kwargs):
        privacy_policies: list[models.PrivacyPolicy] = models.PrivacyPolicy.all()
        if len(privacy_policies) > 1:
            return abort(403, "Multiple privacy_policy found where one was expected")

        privacy_policy: models.PrivacyPolicy
        if not privacy_policies:
            privacy_policy = models.PrivacyPolicy.create(
                **kwargs,
            )
        else:
            privacy_policy = privacy_policies[0]
            privacy_policy.update(**kwargs)
        return self.serialize(privacy_policy)
