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
        privacy_policy = models.PrivacyPolicy.all()
        if privacy_policy == []:
            abort(404, "No privacy_policy data available")
        if len(privacy_policy) > 1:
            abort(403, "Multiple privacy_policy found where one was expected")
        return self.serialize(privacy_policy[0])

    @use_kwargs(PrivacyPolicySchema.to_dict())
    def put(self, **kwargs):
        privacy_policy = models.PrivacyPolicy.all()
        if len(privacy_policy) > 1:
            abort(403, "Multiple privacy_policy found where one was expected")
        if privacy_policy == []:
            privacy_policy = models.PrivacyPolicy.create(
                company="(company name)",
                first_name="(first name)",
                last_name="(last name)",
                street="(street name)",
                house_number="(house number)",
                city="(city name)",
                zip_code="(zip code)",
                phone="(phone number)",
                email="(email address)",
            )
        else:
            privacy_policy = privacy_policy[len(privacy_policy) - 1]
        privacy_policy.update(**kwargs)
        return self.serialize(privacy_policy)
