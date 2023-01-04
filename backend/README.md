# Material Manager Backend - core

## Running the development server

```bash
cd backend
# make install
make run
```

This will start the flask app at http://localhost:5001.
Flask environment variables can be set in `.env`.


## Creating Sample Data

This data is useful for manual user testing.

```bash
cd backend
make sample_data
```

## Deleting Sample Data

```bash
cd backend
make clear_db
```

# Extensions 

- [User](./extensions/user/README.md)
- [Material](./extensions/material/README.md)
- [Inspection](./extensions/inspection/README.md)
- [Rental](./extensions/rental/README.md)
- [Legal](./extensions/legal/README.md)


## Development helpers in `core.helpers`

### Extension

This project get be extended by using the `core.helpers.Extension` class, which
inherits from `flask.Blueprint`. So in Flask-speak it is technically a blueprint.
In order to avoid confusion about this ambiguity, we call the actual Flask extensions
like `Flask-SQLAlchemy` **core extensions** or **Flask extensions** and the ones for
customizing this project just **extensions**.

It can either be

1. instantiated directly or
2. it can be subclassed for executing custom logic.

An extensions consists of models, resources and permissions and can contain custom code
that could be executed on initialization or after all extensions have been initialized.

An example for (1) would be a tiny extension that simply defines a new permission:

```python
from core.helpers.extension import Extension

new_permission = Extension("new_permission", __name__, permissions=[
    dict(name="new permission", description="something meaningful goes here"),
])
```

To (2): For running own code, we can override `before_install`, `after_install` or
`after_installed_all`. Use `before_install` or `after_install` if your code doesn't
depend on other extensions, `after_installed_all` otherwise.

`before_install` and `after_install` get all core Flask extensions as
_keyword arguments_ so that your code doesn't break immediately if a new core
extension is added. So be sureto add `**kwargs` in your signature.

`after_installed_all` receives the Flask app and all installed extensions as arguments.
For example, the user extensions uses this hook in order to create all extensions'
permissions in the database because only this extension itself knows about the
`Permission` model and its implementation.


### CrudModel
Inspired by https://flask-diamond.readthedocs.io/en/stable/_modules/flask_diamond/mixins/crud/

### Resource

### Permissions


### Decorators

#### @permissions_required

Checks the session user's permissions against the given ones.

An example:

```python
@permissions_required("user:read")
    def get(self):
        users = UserModel.all()
        return self.serialize(users)
```
#### @login_required

This decorator should be used for checking if a user is currently logged in
because it's agnostic of the auth implementation.

An example:
```python
@login_required
    def get(self) -> dict:
        return self.schema.dump(current_user)
```
#### @raises

Attaches a tuple of possible errors to a function/method.

By decorating methods that raise errors with `core.helpers.decorators.raises`,
we can achieve 2 things:
- explicitly state the types of raised errors which is helpful for understanding
  the behavior of the method better
- reuse the error types via the `core.helpers.decorators.raised_from` decorator
  when we want to catch them. This way, we don't have to import all the different exceptions.

An example:

```python
from core.helpers.decorators import raises, raised_from

class Math:
    @classmethod
    @raises(TypeError, ValueError)
    def sqrt(cls, x):
        if not isinstance(x, int):
            raise TypeError("x must be an int")
        if x < 0:
            raise ValueError("x must be positive")
        return x ** 1/2

try:
    Math.sqrt(-1)
except raised_from(Math.sqrt):
    print("This is either a value or a type error")
except:
    print(
        "This is weird...might be a syntax error. "
        "Or maybe x implements __pow__ and leaks a password"
    )
```

If we assume that a lot of different errors from different libraries would be raised,
we'd have to know all the imports (think about name clashes).

Furthermore, this approach is dynamic, so whenever the set of potentially raised errors
changes, we only have to adjust 1 place. Thus, refactoring becomes easier.


##### Downside

Unfortunately, when there are transitive dependencies, we have to explicitly state
them. So if some function calls `Math.sqrt` and could raise different errors,
the raised errors of `Math.sqrt` cannot be inferred.

```python
@raises(RuntimeError, *raised_from(Math.sqrt))
def formula(x, y, z):
    if z > 100:
        return Math.sqrt(x) + y
    else:
        raise RuntimeError("...")
```

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

from core.extensions import db
from core.helpers.orm import CrudModel

Model: Type[CrudModel] = db.Model  # Help mypy with dynamic types


class UserNotificationInfo(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.ForeignKey("user.id"))
    notify = db.Column(db.Boolean)
```



### Define resources

For convenience the module `core.helpers` provides a `ModelResource` that
specifies how a model gets serialized. In order to do so, we must define
an inner class `Schema` with an inner class `Meta` that specifies the serialization.
Usually, that means specifying the model and some of its fields, for example

```python
class Schema:
    class Meta:
        model = UserNotificationInfoModel
        fields = ("id", "user_id", "notify")
```

For serializing relationships, you would need to define a schema for the related
model and add a field to the schema like so:

```python
from marshmallow_sqlalchemy.fields import Nested

class Schema:
    user_type = Nested(
        UserTypeSchema(),
        # many=True,
    )
    
    class Meta:
        model = UserNotificationInfoModel
        fields = ("id", "user_id", "notify")
```

Note that `many=True` can be used to specify many related models.

See
[marshmallow_sqlalchemy.SQLAlchemyAutoSchema](https://marshmallow-sqlalchemy.readthedocs.io/en/latest/api_reference.html#marshmallow_sqlalchemy.SQLAlchemyAutoSchema)
for details.

Furthermore, we can specify methods for the HTTP verbs we need.
If want to resource to be queryable via a `GET` request,
we must implement a `get` method.

For our resource, we want to be able to read from and write to the database,
thus we implement a method for both a `GET` and a `POST` request.
We want to make them available at `/user/\<int:user_id\>/notify`, thus for getting
the state of the user with ID 1, we could access `/user/1/notify`. This can be done
using the `url` attribute of the resource.

:warning: Of course, this would be a security issue because everyone could access other users' data!



#### `resource.py`

```python
from flask import request

from core.helpers import ModelResource

from .models import UserNotificationInfo as UserNotificationInfoModel

class UserNotificationInfo(ModelResource):
    url = "/user/<int:user_id>/notify"

    class Schema:
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



# Listen to new material

For sending an e-mail when new material was added to the database,
we need to know somehow when this happens. For achieving this, we make
use of the `model-created` signal.

```python
from typing import Type

from core.signals.model import model_created
from extensions.user.models import User

from .models import UserNotificationInfo


def send_mail(email: str, subject: str, message: str):
    ...


def receiver(sender: Type[UserNotificationInfo], data: UserNotificationInfo):
    for user_info in UserNotificationInfo.filter(notify=True):
        user = User.get(id=user_info.user_id)
        send_mail(
            user.email,
            "New material",
            "New material has arrived!\n\nCheck out https://superawesomematerial.org/material/" + data.id,
        )

model_created.connect(receiver, sender=UserNotificationInfo)
```

Of course, this is by far now an optimal solution as each receiver gets 1 e-mail
per added material (no batching). Also, it is very inefficient because each user is
queried separately.

#