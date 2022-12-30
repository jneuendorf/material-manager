# Material Manager Backend - core

## Running the development server

```bash
cd backend
# make install
make run
```

This will start the flask app at http://localhost:5000.
Flask environment variables can be set in `.env`.



## Creating Sample Data

This data is useful for manual user testing.

```bash
cd backend
make sample_data
```



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

### Resource

### Permissions



### Decorators

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

# extensions


## inspection


## material

## rental

## user

#### `__init__.py`

``` python
from collections.abc import Iterable
from typing import Any

from flask import Flask
from flask_apispec import FlaskApiSpec
from flask_jwt_extended import JWTManager
from flask_restful import Api

from core.helpers.extension import Extension
from core.signals import model_created

from . import models, permissions, resources
from .auth import init_auth


class UserExtension(Extension):
    models = (
        models.User,
        models.Role,
        models.Permission,
    )
    resources = (
        resources.User,
        resources.Users,
        resources.Signup,
        resources.SignupVerification,
        resources.Login,
        resources.Refresh,
        resources.Profile,
    )
    permissions = (
        permissions.superuser,
        permissions.user_read,
        permissions.user_write,
    )

    def before_install(
        self,
        *,
        app: Flask,
        jwt: JWTManager,
        api: Api,
        api_docs: FlaskApiSpec,
        **kwargs,
    ):
        init_auth(jwt)

    def after_installed_all(
        self,
        app: Flask,
        installed_extensions: "Iterable[Extension]",
    ) -> None:
        """Ensures permission instances in the database
        (from permission-data dictionaries).
        """
        with app.app_context():
            for extension in installed_extensions:
                for permission_kwargs in extension.permissions:
                    print(extension.name, "->", permission_kwargs["name"])
                    models.Permission.get_or_create(**permission_kwargs)


user = UserExtension("user", __name__)


def receiver(sender, data):
    print("user instance created:", sender, data)


model_created.connect(
    receiver,
    sender=models.User,
)
```


in the file ` auto.py` we define how passwords can be created.
The authentication is done via JSON Web Tokens (JWT).
This way, we're bound to cookies so that browsers (web applications)
as well as native mobile apps can use the mechanisms for authentication.

#### `auth.py`
``` python
from flask_jwt_extended import JWTManager
from password_strength import PasswordPolicy

from .models import User

# Strong passwords start at 0.66.
# See https://github.com/kolypto/py-password-strength#complexity
password_policy = PasswordPolicy.from_names(
    length=8,  # min length: 8
    nonletters=2,  # need min. 2 non-letter characters (digits, specials, anything)
    strength=0.4,
)


def init_auth(jwt: JWTManager):
    @jwt.user_identity_loader
    def user_identity_lookup(user: User):
        return user.id

    @jwt.user_lookup_loader
    def user_lookup_callback(_jwt_header, jwt_data):
        identity = jwt_data["sub"]
        return User.get_or_none(id=identity)


``` 


The decorator `login_required` should be used for checking if a user is currently logged in
because it's agnostic of the auth implementation.
The function `permissions_required` Checks the session user's permissions against the given ones.
#### `decorators.py`
```python
from functools import wraps

from flask import abort, current_app
from flask_jwt_extended import current_user, jwt_required

from .models import User
from .permissions import superuser

login_required = jwt_required()

def permissions_required(*required_permissions: str):

    def decorator(fn):
        @wraps(fn)
        @jwt_required()
        def wrapper(*args, **kwargs):
            user: User = current_user
            user_permissions = set(permission.name for permission in user.permissions)
            if current_app.debug:
                # TODO: use logging
                print("Checking permissions...")
                print("> required:", required_permissions)
                print("> given:", user_permissions)
            if (
                superuser["name"] in user_permissions
                or set(required_permissions) - user_permissions
            ):
                return abort(403, "Permission denied")
            return fn(*args, **kwargs)

        return wrapper

    return decorator
````


The `User` class defines all user data (name, email address, phone, address, password, ...).
The `Role` und `Permission` classes show which roles we have and which permissions have every roles.
We are mapping between users and their role with the function `UserRoleMApping`und between roles and permissions, which every role has, with the function `RolePermissionMapping``
#### `models.py`
```python

import secrets
from typing import Optional, Type

from passlib.hash import argon2
from sqlalchemy import Table

from core.extensions import db
from core.helpers.decorators import raised_from, raises
from core.helpers.orm import CrudModel

Model: Type[CrudModel] = db.Model


class User(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(length=128), nullable=False, unique=True)
    password_hash = db.Column(db.String(length=512), nullable=False)
    first_name = db.Column(db.String(length=64), nullable=False)
    last_name = db.Column(db.String(length=64), nullable=False)
    membership_number = db.Column(db.String(length=16), nullable=False, default="")
    phone = db.Column(db.String(length=32), nullable=False, default="")
    street = db.Column(db.String(length=100), nullable=False, default="")
    house_number = db.Column(
        db.String(length=8),
        nullable=False,
        default="",
    )  # allow 11A
    city = db.Column(db.String(length=80), nullable=False, default="")
    zip_code = db.Column(
        db.String(length=8),
        nullable=False,
        default="",
    )  # allow leading zeros
    is_active = db.Column(db.Boolean(create_constraint=True), default=False)
    token = db.Column(
        db.String(length=44),
        nullable=False,
        default="",
    )  # for 32 bytes as base64
    # many-to-many
    roles = db.relationship("Role", secondary="user_role_mapping", backref="users")

    @classmethod
    @raises(*raised_from(CrudModel.create))
    def create_from_password(
        cls,
        email: str,
        password: str,
        first_name: str,
        last_name: str,
        membership_number: str = "",
        phone: str = "",
        street: str = "",
        house_number: str = "",
        city: str = "",
        zip_code: str = "",
        *,
        roles: "Optional[list[Role]]" = None,
    ) -> "User":
        password_hash: str = argon2.hash(password)
        token = secrets.token_urlsafe(nbytes=32)
        related = dict(roles=roles) if roles else None
        return cls.create(
            email=email,
            password_hash=password_hash,
            first_name=first_name,
            last_name=last_name,
            membership_number=membership_number,
            phone=phone,
            street=street,
            house_number=house_number,
            city=city,
            zip_code=zip_code,
            is_active=False,
            token=token,
            _related=related,
        )

    def verify_password(self, password: str) -> bool:
        return argon2.verify(password, self.password_hash)

    @property
    def permissions(self) -> "list[Permission]":
        # TODO: use joins
        #  https://docs.sqlalchemy.org/en/14/tutorial/orm_related_objects.html#using-relationships-in-queries
        print(self.roles)
        return [right for role in self.roles for right in role.permissions]


class Role(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String)
    description = db.Column(db.String)
    permissions = db.relationship(
        "Permission",
        secondary="role_permission_mapping",
        backref="roles",
    )


class Permission(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String)
    description = db.Column(db.String)


UserRoleMapping: Table = db.Table(
    "user_role_mapping",
    db.Column("user_id", db.ForeignKey(User.id), primary_key=True),
    db.Column("role_id", db.ForeignKey(Role.id), primary_key=True),
)

RolePermissionMapping: Table = db.Table(
    "role_permission_mapping",
    db.Column("role_id", db.ForeignKey(Role.id), primary_key=True),
    db.Column("permission_id", db.ForeignKey(Permission.id), primary_key=True),
)
```


we define permissions specific to every extension.
#### `permissions.py`
```python



superuser = dict(
    name="superuser",
    description="May to anything",
)
"""This is a special permission that always allows access
when using the `permissions_required` decorator.
"""

user_read = dict(
    name="user:read",
    description="Allows reading any users data",
)

user_write = dict(
    name="user:write",
    description="Allows writing any users data",
)
```

The `Signup`class describes the sign up process. After the user has entered their data and completed the registration process, it will check if the password is good enough and then create a verification link and then email this link and wait for the user to verify their email addressregistration process.
The `login` class describes the login process using the email address and password.

#### `resources.py`
```python

class UserSchema(BaseSchema):
    class Meta:
        model = UserModel
        fields = ("id", "first_name", "last_name", "email", "membership_number")


class User(ModelResource):
    url = "/user/<int:user_id>"
    Schema = UserSchema

    def get(self, user_id: int) -> dict:
        user = UserModel.get(id=user_id)
        return self.schema.dump(user)


class Signup(BaseResource):
    url = "/signup"

    @use_kwargs(
        {
            "email": fields.Str(
                required=True,
                validate=validate.Email(),  # type: ignore
            ),
            "password": fields.Str(required=True),
            "first_name": fields.Str(required=True),
            "last_name": fields.Str(required=True),
            "membership_number": fields.Str(load_default=""),
            "phone": fields.Str(load_default=""),
            "street": fields.Str(load_default=""),
            "house_number": fields.Str(load_default=""),
            "city": fields.Str(load_default=""),
            "zip_code": fields.Str(load_default=""),
        }
    )
    def post(
        self,
        email: str,
        password: str,
        first_name: str,
        last_name: str,
        membership_number: str,
        phone: str,
        street: str,
        house_number: str,
        city: str,
        zip_code: str,
    ):
        failed_tests = password_policy.test(password)
        if failed_tests:
            abort(401, "Password is too weak")

        try:
            # TODO: default role(s)
            user = UserModel.create_from_password(
                email,
                password,
                first_name,
                last_name,
                membership_number,
                phone,
                street,
                house_number,
                city,
                zip_code,
            )
            verification_link = (
                f'{flask_config["CORE_PUBLIC_API_URL"]}'
                f"{SignupVerification.url}"
                f"?user_id={user.id}&token={user.token}"
            )
            mail.send(
                Message(
                    subject="Verify your account",
                    body=f"Click this link to verify your account: {verification_link}",
                    html=f'<p>Click <a href="{verification_link}">here</a> to verify your account</p>',  # noqa
                    recipients=[email],
                )
            )
            return {
                "message": "Signup successful. Verify your e-mail address to login.",
            }
        except (ValueError, IntegrityError):
            return abort(403, "E-mail address already taken")


class SignupVerification(BaseResource):
    url = "/signup/verify"

    @use_kwargs(
        {
            "user_id": fields.Int(required=True),
            "token": fields.Str(required=True),
        },
        location="query",
    )
    def get(self, user_id: int, token: str):
        user = UserModel.get_or_none(id=user_id, token=token)
        if user:
            user.update(
                token="",  # invalidate token
                is_active=True,
            )
            # TODO: How to not hard-code the login URL?
            # TODO: Get FE domain from request header 'Origin'
            return redirect(f'{flask_config["CORE_PUBLIC_FRONTEND_URL"]}/#/login')
        else:
            abort(401, "Verification failed")


class Login(BaseResource):
    url = "/login"

    @use_kwargs({"email": fields.Str(), "password": fields.Str()})
    def post(self, email: Optional[str] = None, password: Optional[str] = None):
        """
        curl -X POST 'http://localhost:5000/login' -H 'Content-Type: application/json' -d '{"email":"root@localhost.com","password":"asdf"}'
        """  # noqa
        user = UserModel.get_or_none(email=email, is_active=True)
        if not user or not user.verify_password(password):
            return abort(
                401,
                "Invalid credentials or your account has not been activated yet",
            )

        additional_claims = {
            "permissions": {
                permission.id: permission.name for permission in user.permissions
            },
        }

        return dict(
            access_token=create_access_token(
                identity=user,
                additional_claims=additional_claims,
            ),
            refresh_token=create_refresh_token(identity=user),
        )


class Refresh(BaseResource):
    url = "/refresh"

    @jwt_required(refresh=True)
    def get(self):
        """
        curl -X GET 'http://localhost:5000/refresh' -H 'Authorization: Bearer <JWT>'
        """
        identity = get_jwt_identity()
        user = UserModel.get_or_none(id=identity)

        if not user:
            return abort(
                401,
                "Account has not been found",
            )

        additional_claims = {
            "permissions": {
                permission.id: permission.name for permission in user.permissions
            },
        }

        return dict(
            access_token=create_access_token(
                identity=current_user,
                fresh=False,
                additional_claims=additional_claims,
            ),
        )


class Profile(ModelResource):
    url = "/user/profile"
    Schema = UserSchema

    @login_required
    def get(self) -> dict:
        return self.schema.dump(current_user)


class Users(ModelListResource):
    url = "/users"
    Schema = UserSchema

    @permissions_required("user:read")
    def get(self):
        """
        curl -X GET 'http://localhost:5000/users' -H 'Authorization: Bearer <JWT>'
        """
        users = UserModel.all()
        return self.serialize(users)
```


