## Rental


We want to write an extension "rental", that take the users to the rental site.
We can create the extension "rental" like this in the [__init__.py](./__init__.py) file

In the file [models.py](./models.py) we define the rental status in the class `RentalStatus`, in addition to that we define every member and every condition in the rental process.
Note, how we create the foreign key referencing the `user` extension.


[resources.py](./resources.py)
For convenience the module `core.helpers` provides a `ModelResource` that
specifies how a model gets serialized. In order to do so, we must define
an inner class `RentalSchema` with an inner class `Meta` that specifies the serialization.
Usually, that means specifying the model and some of its fields, for example

