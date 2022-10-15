# Material Manager Backend - core

## Running

## Extension development - an example

Let's assume, we want to write an extension `material-notifier` 
that informs certain users when new material has been ordered.

Create a python package with the following structure:

```
extensions/material-notifier
├── __init__.py
└── extension.py
```

In order to store which users want to get the e-mail, 
we create a new database model whose instances relate to user instances 
(_composition vs inheritance_). This way, we don't need to take care of 
extending the user model and telling our app that our extended user model 
should be used instead of the built-in one.

This means, we need to use the `user` extension that is built-in.

The core module provides an abstract `Extension` class and some helpers 
that we can use for implementing new extensions. It is a generic class that
takes 2 type variables:

1. One for the defined models (=> database tables) and
2. the other one for the defined resources (=> API endpoints).

Furthermore, 2 abstract method must be implemented:

1. `register_models`
2. `get_resources`

Let's define our extension by subclassing the abstract class `Extension[M, R]`.

```python
class MaterialNotifierExtension(Extension[M, R]):
    name = "material-notifier"
```

For our models we need to define what models we have with which type.
For our extension we only need 1 model `UserNotificationInfo`.

We don't need any resources, so we can just use `tuple` 
(the resources type is bound by `Iterable[Type[ModelResource]]`, 
mean it must be an iterable of resource classes).

```python
# Used for the generic variable M
@dataclass
class Models:
    UserNotificationInfo: DeclarativeMeta


# Used for the generic variable R
Resources = tuple
```

So our class actually inherits like this:

```python
class MaterialNotifierExtension(Extension[Models, Resources]):
    ...
```

Because our `UserNotificationInfo` model requires the `user` extension, 
we need reference to it. Extensions can be accessed via the `app.extensions` 
dictionary. So, we can save the `user` extension in our extension by overriding
the `init_app` method. Since we need to import the `UserExtension` for typing anyway,
we can avoid hard-coding its name:

```python
def init_app(self, app: Flask) -> None:
    # The key 'user' comes from the user extension's 'name' attribute.
    self.user = app.extensions[UserExtension.name]
```

So now, we have access to the initialized `user` extension and 
can use all of its public API. In particular, we can access the `User` model
to create a foreign key to it.


### `extension.py`

```python
from dataclasses import dataclass

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import DeclarativeMeta

# Abstract class
from core.helpers.extension import Extension
# Use other extensions (avoid cycles yourself!)
from extensions.user import UserExtension


@dataclass
class Models:
    UserNotificationInfo: DeclarativeMeta

    
Resources = tuple


class MaterialNotifierExtension(Extension[Models, Resources]):
    name = "material-notifier"
    user: UserExtension
    
    def init_app(self, app: Flask) -> None:
        self.user = app.extensions[UserExtension.name]

    def register_models(self, db: SQLAlchemy):
        Model: DeclarativeMeta = db.Model  # typing stuff only
        User = self.user.models.User

        class UserNotificationInfo(Model):
            id = db.Column(db.Integer, primary_key=True)
            user_id = db.Column(db.ForeignKey(
                User.id  # type: ignore
            ))
            notify = db.Column(db.Boolean)

        return Models(
            UserNotificationInfo=UserNotificationInfo,
        )

    def get_resources(self, db: SQLAlchemy):
        return ()
```


Finally, in the `__init__.py` we provide the extension class on the package level for convenience:


### `__init__.py`

```python
from .extension import MaterialNotifierExtension
```
