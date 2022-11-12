from typing import List

from flask import abort
from flask_apispec import use_kwargs
from marshmallow import fields
from sqlalchemy.exc import IntegrityError
from sympy import field

from core.helpers.resource import ModelListResource, ModelResource
from core.helpers.schema import BaseSchema, ModelConverter

from . import models

class CommentSchema(BaseSchema):
    class Meta:
        model = models.Comment
        fields = (
            "id",
            "inspection_id",
            "comment",
            "photo",
        )
    

# class Comment(ModelResource):
#    Schema = CommentSchema
    
    
class InspectionSchema(BaseSchema):
    class Meta:
        model = models.Inspection
        fields = (
            "id", 
            "inspector_id",
            "material_id",
            "date",
            "type",
            
        )
    
    
class Inspection(ModelResource):
    url = [
         "/inspection",
        "/inspection/<int:inspection_id>",
    ]
    Schema = InspectionSchema
    
    def get(self, inspection_id: int):
        inspection = models.Inspection.get(inspection_id)
        return inspection
    
    def post(self, inspection_id: int):
        pass



# I thought we should return all comments by material_id but Do we need Inspection attributes like date?
class Comments(ModelResource):
    url = "/inspections/<int:material_id>"
    Schema = CommentSchema
    
    def get(self, material_id: int):
        inspections = models.Comment.get(material_id)
        return self.serialize(inspections)
