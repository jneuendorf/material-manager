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
    

class Comment(ModelResource):
    url = "/comment"
    Schema = CommentSchema
    
    
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
        "/inspections/<int:material_id>",
    ]
    Schema = InspectionSchema
    
    def get(self, inspection_id: int):
        pass
    
    def post(self, inspection_id: int):
        pass
