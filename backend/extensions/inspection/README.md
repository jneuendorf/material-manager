# Inspection extension

we want to define the extension inspection in the file [__init__.py](./__init__.py)

## Data model

In the file [models.py](./models.py) we define the class `InspectionType` to show the different typs of inspection, the class `inspection`to connect between inspections and inspectors and the class `comment` that show, how we can comment as inspectors.

## Resources
```python
class Comment(ModelResource):
    url = "/comment"
    Schema = CommentSchema
```
```python
class Inspection(ModelResource):
    url = [
        "/inspection",
        "/inspection/<int:inspection_id>",
    ]
    Schema = InspectionSchema
```
For details see [resources.py](./resources.py)
