# Inspection extension

What is it

## Data model

For details see [models.py](./models.py)

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