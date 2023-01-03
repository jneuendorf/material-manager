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

in the class `__init__.py`we define the extention "material"
#### `__init__.py`

``` python
from core.helpers.extension import Extension

from . import models, resources
from .config import STATIC_FOLDER, STATIC_URL_PATH

material = Extension(
    "material",
    __name__,
    static_url_path=STATIC_URL_PATH,
    static_folder=STATIC_FOLDER,
    models=(
        models.MaterialType,
        models.Material,
        models.SerialNumber,
        models.PurchaseDetails,
        models.MaterialSet,
        models.MaterialTypeSetMapping,
        models.Property,
        models.MaterialTypePropertyTypeMapping,
    ),
    resources=(
        resources.Material,
        resources.Materials,
        resources.MaterialType,
        resources.MaterialTypes,
        resources.PropertyTypes,
    ),
)

```

#### `models.py`



``` python
import enum
from typing import Type

from sqlalchemy import Table
from sqlalchemy.schema import UniqueConstraint

from core.extensions import db
from core.helpers.orm import CrudModel
from extensions.common.models import File

Model: Type[CrudModel] = db.Model


class MaterialType(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(length=32), unique=True)
    description = db.Column(db.String(length=80), default="")
    sets = db.relationship(
        "MaterialSet",
        secondary="material_type_set_mapping",
        backref="material_types",
    )
    # many to many
    property_types = db.relationship(
        "PropertyType",
        secondary="material_type_property_type_mapping",
        backref="material_types",
    )


class PropertyType(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(length=32), unique=True)
    description = db.Column(db.String(length=80), default="")
    unit = db.Column(db.String(length=12))


class Property(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    # many to one (FK here)
    property_type_id = db.Column(db.ForeignKey(PropertyType.id), nullable=False)
    property_type = db.relationship("PropertyType", backref="properties")
    value = db.Column(db.String(length=32))

    __table_args__ = (
        UniqueConstraint(
            "property_type_id",
            "value",
            name="type_value_uc",
        ),
    )

    def __str__(self) -> str:
        unit = self.property_type.unit
        return (
            f"{self.property_type.name}: " f"{self.value}{' ' + unit if unit else ''}"
        )


MaterialTypePropertyTypeMapping: Table = db.Table(
    "material_type_property_type_mapping",
    db.Column("material_type_id", db.ForeignKey(MaterialType.id), primary_key=True),
    db.Column("property_type_id", db.ForeignKey(PropertyType.id), primary_key=True),
)


class PurchaseDetails(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    purchase_date = db.Column(db.Date)
    invoice_number = db.Column(db.String(length=32))
    merchant = db.Column(db.String(length=80))
    purchase_price = db.Column(db.Float)
    suggested_retail_price = db.Column(db.Float, nullable=True)

    __table_args__ = (
        UniqueConstraint(
            "merchant",
            "invoice_number",
            name="merchant_invoice_number_uc",
        ),
    )


class Condition(enum.Enum):
    OK = "OK"
    REPAIR = "REPAIR"
    BROKEN = "BROKEN"


class Material(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(length=80), nullable=False)
    installation_date = db.Column(db.Date, nullable=True)  # Inbetriebnahme
    max_operating_date = db.Column(db.Date, nullable=True)  # Lebensdauer ("MHD")
    max_days_used = db.Column(
        db.Integer,
        nullable=False,
    )  # maximale Gebrauchsdauer, compare to 'days_used'
    days_used = db.Column(db.Integer, nullable=False, default=0)
    instructions = db.Column(db.Text, nullable=False, default="")
    next_inspection_date = db.Column(db.Date, nullable=False)
    rental_fee = db.Column(db.Float, nullable=False)
    # We need `create_constraint=True` because SQLite doesn't support enums natively
    condition = db.Column(
        db.Enum(Condition, create_constraint=True),
        nullable=False,
        default=Condition.OK,
    )
    # many to one (FK here)
    material_type_id = db.Column(db.ForeignKey(MaterialType.id), nullable=False)
    material_type = db.relationship("MaterialType", backref="materials")
    # many to one (FK here)
    purchase_details_id = db.Column(db.ForeignKey(PurchaseDetails.id), nullable=True)
    purchase_details = db.relationship("PurchaseDetails", backref="materials")
    # one to many (FK on child)
    serial_numbers = db.relationship("SerialNumber", backref="material")
    # one to many (FK on child)
    inventory_numbers = db.relationship("InventoryNumber", backref="material")
    # many to many
    images = db.relationship(
        "File",
        secondary="material_image_mapping",
    )
    # many to many
    properties = db.relationship(
        "Property",
        secondary="material_property_mapping",
        backref="materials",
    )

    @property
    def description(self):
        return f"{self.name} ({', '.join(str(prop) for prop in self.properties)})"

    def save(self) -> None:
        if not self.serial_numbers:
            raise ValueError("A material must have at least 1 associated serial number")
        super().save()


MaterialImageMapping: Table = db.Table(
    "material_image_mapping",
    db.Column("material_id", db.ForeignKey(Material.id), primary_key=True),
    db.Column("file_id", db.ForeignKey(File.id), primary_key=True),
)

MaterialPropertyMapping: Table = db.Table(
    "material_property_mapping",
    db.Column("material_id", db.ForeignKey(Material.id), primary_key=True),
    db.Column("property_id", db.ForeignKey(Property.id), primary_key=True),
)


class InventoryNumber(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    inventory_number = db.Column(db.String(length=20), nullable=False, unique=True)
    material_id = db.Column(db.ForeignKey(Material.id))


class SerialNumber(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    serial_number = db.Column(db.String(length=32))
    production_date = db.Column(db.Date)
    manufacturer = db.Column(db.String(length=80))
    material_id = db.Column(db.ForeignKey(Material.id))

    __table_args__ = (
        UniqueConstraint(
            "manufacturer",
            "serial_number",
            name="manufacturer_serial_number_uc",
        ),
    )


class MaterialSet(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    # many to many
    images = db.relationship(
        "File",
        secondary="material_set_image_mapping",
    )
    # images = File.reverse_generic_relationship("MaterialSet")
    name = db.Column(db.String(length=32))


MaterialSetImageMapping: Table = db.Table(
    "material_set_image_mapping",
    db.Column("material_set_id", db.ForeignKey(MaterialSet.id), primary_key=True),
    db.Column("file_id", db.ForeignKey(File.id), primary_key=True),
)

MaterialTypeSetMapping: Table = db.Table(
    "material_type_set_mapping",
    db.Column("material_set_id", db.ForeignKey(MaterialSet.id), primary_key=True),
    db.Column("material_type_id", db.ForeignKey(MaterialType.id), primary_key=True),
)

```


### resources
#### `material_type.py`



``` python
from flask_apispec import use_kwargs

from core.helpers.resource import ModelListResource, ModelResource
from extensions.material import models
from extensions.material.resources.schemas import MaterialTypeSchema


class MaterialType(ModelResource):
    url = [
        "/material_type",
        "/material_type/<int:property_type_id>",
    ]
    Schema = MaterialTypeSchema

    def get(self, property_type_id: int):
        """Test with
        curl -X GET "http://localhost:5000/material_type/1"
        """
        material_type = models.MaterialType.get(id=property_type_id)
        return self.serialize(material_type)

    @use_kwargs(
        MaterialTypeSchema.to_dict(
            name=dict(required=True),
            description=dict(required=True),
        )
    )
    def post(self, **kwargs) -> dict:
        """Test with
        curl -X POST "http://localhost:5000/material_type" \
        -H 'Content-Type: application/json' \
        -d '{"name":"Seile", "description":"Seil zum Klettern"}'
        """
        material_type = models.MaterialType.create(**kwargs)
        return self.serialize(material_type)


class MaterialTypes(ModelListResource):
    url = "/material_types"
    Schema = MaterialTypeSchema

    def get(self):
        material_types = models.MaterialType.all()
        return self.serialize(material_types)

```
#### `material.py`



``` python
from datetime import date
from typing import Optional

from flask import abort
from flask_apispec import use_kwargs
from marshmallow import fields
from sqlalchemy.exc import IntegrityError

from core.helpers.resource import ModelListResource, ModelResource
from extensions.common.decorators import FileSchema, with_files
from extensions.common.models import File
from extensions.material import models
from extensions.material.resources.schemas import (
    InventoryNumberSchema,
    MaterialSchema,
    PlainPropertySchema,
    SerialNumberSchema,
)


class Material(ModelResource):
    url = [
        "/material",
        "/material/<int:material_id>",
    ]
    Schema = MaterialSchema

    def get(self, material_id: int):
        """Test with
        curl -X GET "http://localhost:5000/material/1"
        """
        material = models.Material.get(id=material_id)
        return self.serialize(material)

    @use_kwargs(MaterialSchema.to_dict(exclude=["image_urls"]))
    def post(
        self,
        *,
        material_type: models.MaterialType,
        serial_numbers: list[models.SerialNumber],
        properties: Optional[list[models.Property]] = None,
        # TODO: handle image uploads
        images: Optional[list[models.File]] = None,
        purchase_details: Optional[models.PurchaseDetails] = None,
        **kwargs,
    ) -> dict:
        related = dict(
            material_type=material_type,
            serial_numbers=serial_numbers,
        )
        if properties:
            related["properties"] = properties
        if images:
            related["images"] = images
        if purchase_details:
            related["purchase_details"] = purchase_details
        try:
            material = models.Material.create(
                _related=related,
                **kwargs,
            )
        except IntegrityError as e:
            print(e)
            abort(403, "Duplicate serial number for the same manufacturer")

        return self.serialize(material)  # noqa


class Materials(ModelListResource):
    url = "/materials"
    Schema = MaterialSchema

    def get(self):
        materials = models.Material.all()
        return self.serialize(materials)

    @use_kwargs(
        {
            "serial_numbers": fields.List(
                fields.List(
                    fields.Nested(SerialNumberSchema()),
                ),
            ),
            "inventory_numbers": fields.List(
                fields.Nested(InventoryNumberSchema(exclude=["id"])),
            ),
            "images": fields.List(
                fields.Nested(FileSchema()),
            ),
            # Manual handling because resolving nested and cyclic relationships is very
            # complicated and error-prone
            "properties": fields.List(
                fields.Nested(PlainPropertySchema()),
            ),
            **MaterialSchema.to_dict(
                include=[
                    "material_type",
                    "purchase_details",
                    "max_operating_date",
                    "max_days_used",
                    "instructions",
                    "next_inspection_date",
                    "rental_fee",
                ],
            ),
        }
    )
    @with_files("images", related_extension="material")
    def post(
        self,
        material_type: models.MaterialType,
        serial_numbers: list[list[models.SerialNumber]],
        inventory_numbers: list[models.InventoryNumber],
        purchase_details: models.PurchaseDetails,
        images: list[File],
        max_operating_date: date,
        max_days_used: int,
        instructions: str,
        next_inspection_date: date,
        rental_fee: float,
        properties: list[dict],
    ):
        """Saves a batch of materials that share some identical data. I.e.
        - purchase details
        - material type
        - images
        """

        if len(serial_numbers) != len(inventory_numbers):
            return abort(
                400,
                "number of serial numbers does not match number of inventory numbers",
            )

        property_instances = [
            models.Property.get_or_create(
                value=prop["value"],
                _related=dict(
                    property_type=models.PropertyType.get_or_create(
                        **prop["property_type"]
                    ),
                ),
            )
            for prop in properties
        ]
        material_type = material_type.ensure_saved()
        purchase_details = purchase_details.ensure_saved()
        if material_type.id is None or purchase_details.id is None:
            return abort(
                500,
                "error while trying to persist material type or purchase details",
            )

        material_ids = []
        try:
            for serial_nums, inventory_num in zip(serial_numbers, inventory_numbers):
                material = models.Material.create(
                    name="",
                    max_operating_date=max_operating_date,
                    max_days_used=max_days_used,
                    instructions=instructions,
                    next_inspection_date=next_inspection_date,
                    rental_fee=rental_fee,
                    _related=dict(
                        material_type=material_type,
                        purchase_details=purchase_details,
                        serial_numbers=list(serial_nums),
                        inventory_numbers=[inventory_num],
                        images=images,
                        properties=property_instances,
                    ),
                )
                print(material)
                material_ids.append(material.id)
        except Exception as e:
            print(e)
            return abort(500, "unknown error")

        return {
            "materials": material_ids,
        }

```
#### `property.py`



``` python
from typing import cast

from sqlalchemy.sql import Select

from core.helpers.resource import ModelListResource
from extensions.material.models import MaterialType, PropertyType
from extensions.material.resources.schemas import PropertyTypeSchema


class PropertyTypes(ModelListResource):
    url = [
        "/property_types/<string:material_type_name>",
    ]
    Schema = PropertyTypeSchema

    def get(self, material_type_name: str):
        query = MaterialType.get_query()
        statement = cast(
            Select,
            query.select().where(MaterialType.name.ilike(f"%{material_type_name}%")),
        )
        result = query.execute(statement)
        material_types: list[MaterialType] = result.scalars().all()
        # Ensure distinct property types because found material types could have
        # overlapping property types.
        distinct_property_types: dict[int, PropertyType] = {
            property_type.id: property_type
            for material_type in material_types
            for property_type in material_type.property_types
        }
        return self.serialize(list(distinct_property_types.values()))

```
#### `schemas.py`
``` python
from marshmallow import Schema as PlainSchema
from marshmallow import fields

from core.helpers.extension import url_join
from core.helpers.schema import BaseSchema, ModelConverter

from .. import models
from ..config import STATIC_URL_PATH


class SerialNumberSchema(BaseSchema):
    class Meta:
        model = models.SerialNumber
        fields = ("serial_number", "production_date", "manufacturer")


class InventoryNumberSchema(BaseSchema):
    class Meta:
        model = models.InventoryNumber
        fields = ("id", "inventory_number")


class MaterialTypeSchema(BaseSchema):
    class Meta:
        model = models.MaterialType
        fields = ("id", "name", "description")
        # load_only = ("id",)


class PropertyTypeSchema(BaseSchema):
    class Meta:
        model = models.PropertyType
        fields = ("id", "name", "unit")


class PlainPropertyTypeSchema(PlainSchema):
    name = fields.Str(required=True)
    unit = fields.Str()


class PropertySchema(BaseSchema):
    property_type = fields.Nested(PropertyTypeSchema())

    class Meta:
        model = models.Property
        fields = ("id", "property_type", "value")


class PlainPropertySchema(PlainSchema):
    property_type = fields.Nested(PlainPropertyTypeSchema())
    value = fields.Str()


class PurchaseDetailsSchema(BaseSchema):
    class Meta:
        model = models.PurchaseDetails
        fields = (
            "id",
            "purchase_date",
            "invoice_number",
            "merchant",
            "purchase_price",
            "suggested_retail_price",
        )


class MaterialSchema(BaseSchema):
    material_type = fields.Nested(MaterialTypeSchema())
    serial_numbers = fields.List(fields.Nested(SerialNumberSchema()))
    inventory_numbers = fields.List(fields.Nested(InventoryNumberSchema()))
    purchase_details = fields.Nested(PurchaseDetailsSchema())
    image_urls = fields.Method("get_image_urls")
    properties = fields.List(fields.Nested(PropertySchema()))

    class Meta:
        # TODO: specifying model_converter should not be necessary
        #  Check why the metaclass doesn't work
        model_converter = ModelConverter
        model = models.Material
        dump_only = ("image_urls",)

    def get_image_urls(self, obj: models.Material):
        return [url_join(STATIC_URL_PATH, image.path) for image in obj.images]

```

## rental
We want to write an extension "rental", that take the users to the rental site.
we can create the extension "rental" like this in the `__init__.py` file:

#### `__init__.py`



``` python
from core.helpers.extension import Extension

from . import models, resources

rental = Extension(
    "rental",
    __name__,
    static_url_path="/rental/static",
    static_folder="static",
    template_folder="templates",
    models=(
        models.Rental,
        # models.RentalStatus,
        models.MaterialRentalMapping,
    ),
    resources=(
        resources.Rental,
        resources.Rentals,
        resources.RentalConfirmationPdf,
        resources.RentalConfirmationHtml,
    ),
)

```

In the following, we define our `models` and `resources`.
We define the rental status in the class `RentalStatus`, in addition to that we define every member and every condition in the rental process.
Note, how we create the foreign key referencing the `user` extension.

#### `models.py`

``` python

class RentalStatus(enum.Enum):
    LENT = "LENT"
    AVAILABLE = "AVAILABLE"
    UNAVAILABLE = "UNAVAILABLE"
    RETURNED = "RETURNED"


class Rental(Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    # many to one (FK here)
    customer_id = db.Column(db.ForeignKey("user.id"))
    customer = db.relationship(
        "User",
        # foreign_keys=[db.Column("rental.customer_id")],
        backref="customer_rentals",
        primaryjoin="Rental.customer_id == User.id",
        uselist=False,
    )
    # many to one (FK here)
    lender_id = db.Column(db.ForeignKey("user.id"))
    lender = db.relationship(
        "User",
        backref="lender_rentals",
        primaryjoin="Rental.lender_id == User.id",
        uselist=False,
    )
    # many to one (FK here)
    return_to_id = db.Column(db.ForeignKey("user.id"))
    return_to = db.relationship(
        "User",
        backref="receiver_rentals",
        primaryjoin="Rental.return_to_id == User.id",
        uselist=False,
    )

    materials = db.relationship(
        "Material", secondary="material_rental_mapping", backref="rental"
    )

    rental_status = db.Column(
        db.Enum(RentalStatus, create_constraint=True),
        nullable=False,
        default=RentalStatus.AVAILABLE,
    )
    cost = db.Column(db.Float, nullable=False)
    discount = db.Column(db.Float, default=0)
    deposit = db.Column(db.Float, default=0)  # Kaution
    created_at = db.Column(db.DateTime, default=lambda: datetime.now())
    start_date = db.Column(db.Date, nullable=False)
    end_date = db.Column(db.Date, nullable=False)
    usage_start_date = db.Column(db.Date, nullable=True)
    usage_end_date = db.Column(db.Date, nullable=True)


MaterialRentalMapping: Table = db.Table(
    "material_rental_mapping",
    db.Column("rental_id", db.ForeignKey(Rental.id), primary_key=True),
    db.Column("material_id", db.ForeignKey("material.id"), primary_key=True),
)

```

### Define resources

For convenience the module `core.helpers` provides a `ModelResource` that
specifies how a model gets serialized. In order to do so, we must define
an inner class `RentalSchema` with an inner class `Meta` that specifies the serialization.
Usually, that means specifying the model and some of its fields, for example

#### `resources.py`

``` python


class RentalSchema(BaseSchema):
    lender = fields.Nested(UserSchema(only=["id"]))
    customer = fields.Nested(UserSchema(only=["id"]))
    return_to = fields.Nested(UserSchema(only=["id"]))
    materials = fields.List(fields.Nested(MaterialSchema(only=["id"])))

    class Meta:
        model_converter = ModelConverter
        model = models.Rental
```

To add a new rental, we musst define the class `Rental(ModelResource)`
To fetch all rentals, wu have to define the class `Rentals(ModelListResource)`
And we define the class `RentalConfirmationPdf(BaseResource)`with the extention to the rental conformation pdf.

For our resource, we want to be able to read from and write to the database,
thus we implement a method for both a `GET` and a `POST` request.

#### `resources.py`
``` python
class Rental(ModelResource):
    url = ["/rental", "/rental/<int:rental_id>"]
    Schema = RentalSchema

    # Adds a new rental /rental
    @use_kwargs(
        {
            **RentalSchema.to_dict(
                include=[
                    "customer",
                    "lender",
                    "materials",
                    "cost",
                    "discount",
                    "deposit",
                    "start_date",
                    "end_date",
                    "usage_start_date",
                    "usage_end_date",
                ],
            ),
        }
    )
    def post(
        self,
        customer: User,
        lender: User,
        materials: list[Material],
        cost: float,
        discount: float,
        deposit: float,
        start_date: date,
        end_date: date,
        usage_start_date: Optional[date] = None,
        usage_end_date: Optional[date] = None,
    ) -> dict:
        """Test with
        curl -X POST "http://localhost:5000/rental" \
        -H 'Content-Type: application/json' \
        -d '{}'
        """
        # query = Material.get_query()
        # material_instances = query.execute(
        #     query.db.select(Material, Material.id.in_(materials)),
        # )
        # print(material_instances)
        rental = models.Rental.create(
            _related=dict(
                customer=customer,
                lender=lender,
                materials=materials,
            ),
            cost=cost,
            discount=discount,
            deposit=deposit,
            start_date=start_date,
            end_date=end_date,
            usage_start_date=usage_start_date,
            usage_end_date=usage_end_date,
        )
        return {
            "id": rental.id,
        }

    # update a rental by using rental_id
    @use_kwargs(RentalSchema.to_dict())
    def put(self, rental_id, **kwargs):
        rental = models.Rental.get(id=rental_id)
        models.Rental.update(rental, **kwargs)
        return self.serialize(rental)

    def get(self, rental_id: int):
        """Test with
        curl -X GET "http://localhost:5000/rental/1"
        """
        rental = models.Rental.get(id=rental_id)
        return self.serialize(rental)


# Fetches all rentals.
class Rentals(ModelListResource):
    url = "/rentals"
    Schema = RentalSchema

    def get(self):
        rentals = models.Rental.all()
        return self.serialize(rentals)


def render_rental_confirmation(
    rental: models.Rental,
    total_price: float,
    logo_url: str,
    lang: str,
):
    return render_template(
        f"rental_confirmation-{lang}.html",  # noqa
        # Avoid as many internal requests as possible
        # TODO: Shrink styles
        bootstrap=(Path(__file__).parent / "static" / "bootstrap.min.css").read_text(),
        logo_url=logo_url,
        rental=rental,
        total_price=total_price,
    )


class RentalConfirmationPdf(BaseResource):
    url = [
        "/rental/<int:rental_id>/confirmation",
        "/rental/<int:rental_id>/confirmation/<string:lang>",
    ]

    @login_required
    def get(self, rental_id: int, lang: str = "de"):
        user: User = current_user
        rental: models.Rental = models.Rental.get(id=rental_id)
        if rental.customer.id != user.id:
            return abort(403, "Permission denied")

        rental = models.Rental.get(id=rental_id)
        return render_pdf(
            HTML(
                string=render_rental_confirmation(
                    rental,
                    logo_url=url_for("rental.static", filename="jdav-logo.jpg"),
                    total_price=(
                        sum(m.rental_fee for m in rental.materials)
                        + rental.deposit
                        - rental.discount
                    ),
                    lang=lang,
                ),
            ),
        )


class RentalConfirmationHtml(BaseResource):
    url = "/rental/<int:rental_id>/confirmation.html"

    def get(self, rental_id: int):
        if not current_app.debug:
            abort(500, "debug only")

        rental = models.Rental.get(id=rental_id)
        return make_response(
            render_rental_confirmation(
                rental=rental,
                logo_url=url_for("rental.static", filename="jdav-logo.jpg"),
                total_price=(
                    sum(m.rental_fee for m in rental.materials)
                    + rental.deposit
                    - rental.discount
                ),
                lang="de",
            ),
        )

```
#### `signals.py`

``` python
from blinker import Namespace

rental = Namespace()

export = rental.signal("rental-export")
request_sent = rental.signal("rental-request_sent")
request_confirmed = rental.signal("rental-request_confirmed")
invoice_email_sent = rental.signal("rental-invoice_email_sent")
material_ready = rental.signal("rental-material_ready")
material_ready_email_sent = rental.signal("rental-material_ready_email_sent")
picked_up = rental.signal("rental-picked_up")
returned = rental.signal("rental-returned")
not_returned = rental.signal("rental-not_returned")
inspection_material_ok = rental.signal("rental-inspection-material_ok")
inspection_material_needs_inspection = rental.signal(
    "rental-inspection-material_needs_inspection"
)
inspection_material_broken = rental.signal("rental-inspection-material_broken")


``` 

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


