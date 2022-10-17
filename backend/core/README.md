# Material Manager Backend - core

## Running

## Extension development - an example

### Create a new extension

Let's assume, we want to write an extension `material-notifier`
that informs certain users when new material has been ordered.

Create a python package with the following structure:

```
extensions/material-notifier
├── __init__.py
├── models.py
└── resources.py
```

In order to store which users want to get the e-mail,
we create a new database model `UserNotificationInfo` whose instances relate to user instances
(_composition vs inheritance_). This way, we don't need to take care of
extending the user model and telling our app that our extended user model
should be used instead of the built-in one.

For the user to be able to update their preference on whether to get notified or not,
we want to add a new API endpoint (aka. URL). Since this new URL relates to our new
model, we need to add a resource for the model.

:warning: Watch out that you don't create cyclic dependencies between extensions
when importing models from other modules.

So now, we can create our new extension like this in the `__init__.py` file:

```python
from core.helpers.extension import Extension

from . import models, resources


material_notifier = Extension(
    "material-notifier",
    __name__,
    models=(models.UserNotificationInfo,),
    resources=(resources.UserNotificationInfo,),
)
```

In the following, we define our `models` and `resources`.

### Define models

Let's fill our `models.py` file.
Note, how we create the foreign key referencing the `user` extension.


#### `models.py`

```python
from typing import Type

from core.app import db
from core.helpers.orm import CrudModel
from extensions.user.models import User

Model: Type[CrudModel] = db.Model  # Help mypy with dynamic types


class UserNotificationInfo(Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.ForeignKey(User.id))
    notify = db.Column(db.Boolean)
```

### Define resource

For convenience the module `core.helpers` provides a `ModelResource` that 
specifies how a model gets serialized. In order to do so, we must define 
an inner class `Meta` that specifies the serialization. 
Usually, that means specifying the model and some of its fields, for example

```python
class Meta:
    model = UserNotificationInfoModel
    fields = ("id", "user_id", "notify")
```

See 
[marshmallow_sqlalchemy.SQLAlchemySchema](https://marshmallow-sqlalchemy.readthedocs.io/en/latest/api_reference.html#marshmallow_sqlalchemy.SQLAlchemySchema)
for details.

Furthermore, we can specify methods for the HTTP verbs we need.
If want to resource to be queryable via a `GET` request, 
we must implement a `get` method.

For our resource, we want to be able to read from and write to the database,
thus we implement a method for both a `GET` and a `POST` request:



#### `resource.py`

```python
from flask import request

from core.helpers import ModelResource

from .models import UserNotificationInfo as UserNotificationInfoModel

class UserNotificationInfo(ModelResource):
    url = "/{ext_name}/<int:user_id>"

    class Meta:
        model = UserNotificationInfoModel
        fields = ("id", "user_id", "notify")

    def get(self, user_id: int):
        user_notification_info = UserNotificationInfoModel.get(user_id=user_id)
        return self.serialize(user_notification_info)

    def post(self, user_id: int):
        notify: bool = request.form["notify"]
        user_notification_info = UserNotificationInfoModel.get(user_id=user_id)
        user_notification_info.update(notify=notify).save()
        return "success"
```
