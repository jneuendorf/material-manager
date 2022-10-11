from dav_material.db import db

# create_all() turns each class into a table
# UserRole class name will be auto-renamed user_role in the DB

# tables without foreign key


class Material(db.Model):
    MaterialID = db.Column(db.Integer, primary_key=True)
    SerialNumber = db.Column(db.String)
    InventoryNumber = db.Column(db.String)
    Manufacturer = db.Column(db.String)
    MaxLifeExpectancy = db.Column(db.String)
    MaxServiceDuration = db.Column(db.String)
    InstallationDate = db.Column(db.String)
    Instructions = db.Column(db.String)
    NextInspectionDate = db.Column(db.String)
    # SetID = db.Column(db.String)
    RentalFee = db.Column(db.String)
    Condition = db.Column(db.String)
    UsageInDays = db.Column(db.String)


class Set(db.Model):
    SetID = db.Column(db.Integer, primary_key=True)
    Name = db.Column(db.String)
    Description = db.Column(db.String)


class Property(db.Model):
    PropertyID = db.Column(db.Integer, primary_key=True)
    Name = db.Column(db.String)
    Description = db.Column(db.String)
    Value = db.Column(db.String)
    Unit = db.Column(db.String)


class User(db.Model):
    UserID = db.Column(db.Integer, primary_key=True)
    FirsName = db.Column(db.String)
    LastName = db.Column(db.String)
    MembershipNumber = db.Column(db.Integer)


class Role(db.Model):
    RoleID = db.Column(db.Integer, primary_key=True)
    Name = db.Column(db.String)
    Description = db.Column(db.String)


class Rights(db.Model):
    RightID = db.Column(db.Integer, primary_key=True)
    Name = db.Column(db.String)
    Description = db.Column(db.String)


class RentalStatus(db.Model):
    RentalStatusID = db.Column(db.Integer, primary_key=True)
    Name = db.Column(db.String)


# tables with foreign key


class Return(db.Model):
    ReturnID = db.Column(db.Integer, primary_key=True)
    Comment = db.Column(db.String)
    Photo = db.Column(db.String)
    MaterialID = db.Column(db.ForeignKey(Material.MaterialID))


class Rental(db.Model):
    RentalID = db.Column(db.Integer, primary_key=True)
    CustomerID = db.Column(db.ForeignKey(User.UserID))
    LenderID = db.Column(db.ForeignKey(User.UserID))
    TotalAmount = db.Column(db.Integer)
    RentalStatusID = db.Column(db.ForeignKey(RentalStatus.RentalStatusID))
    Date = db.Column(db.Integer)
    RentalDuration = db.Column(db.Integer)
    UsageDuration = db.Column(db.Integer)
    ReturnToID = db.Column(db.ForeignKey(User.UserID))
    Deposit = db.Column(db.Integer)


class PSAInspection(db.Model):
    PSAID = db.Column(db.Integer, primary_key=True)
    InspectorID = db.Column(db.ForeignKey(User.UserID))
    Date = db.Column(db.String)
    Status = db.Column(db.String)
    RentalID = db.Column(db.ForeignKey(Rental.RentalID))


# tables with foreign key as primary key


class PurchaseDetails(db.Model):
    MaterialID = db.Column(db.ForeignKey(Material.MaterialID), primary_key=True)
    PurchaseDate = db.Column(db.String)
    Invoicenumber = db.Column(db.Integer)
    Merchant = db.Column(db.String)
    ProductionDate = db.Column(db.String)
    PurchasePrice = db.Column(db.String)
    SuggestedRetailPrice = db.Column(db.String)


class EquipmentType(db.Model):
    MaterialID = db.Column(db.ForeignKey(Material.MaterialID), primary_key=True)
    Description = db.Column(db.String)


class PSAComment(db.Model):
    PSAID = db.Column(db.ForeignKey(PSAInspection.PSAID), primary_key=True)
    MaterialID = db.Column(db.ForeignKey(Material.MaterialID), primary_key=True)
    Comment = db.Column(db.String)
    Photo = db.Column(db.String)


class Customer(db.Model):
    UserID = db.Column(db.ForeignKey(User.UserID), primary_key=True)
    FirsName = db.Column(db.String)
    LastName = db.Column(db.String)
    Email = db.Column(db.String)
    Phone = db.Column(db.String)
    Address1 = db.Column(db.String)
    Address2 = db.Column(db.String)
    Category = db.Column(db.String)


# mapping tables m2m
# source: https://flask-sqlalchemy.palletsprojects.com/en/3.0.x/models/

RoleRightsMapping = db.Table(
    "role_rights_mapping",
    db.Column("RightID", db.ForeignKey(Rights.RightID), primary_key=True),
    db.Column("RoleID", db.ForeignKey(Role.RoleID), primary_key=True),
)

UserRoleMapping = db.Table(
    "user_role_mapping",
    db.Column("UserID", db.ForeignKey(User.UserID), primary_key=True),
    db.Column("RoleID", db.ForeignKey(Role.RoleID), primary_key=True),
)

MaterialPropertyMapping = db.Table(
    "material_property_mapping",
    db.Column("MaterialID", db.ForeignKey(Material.MaterialID), primary_key=True),
    db.Column("RoleID", db.ForeignKey(Role.RoleID), primary_key=True),
)

MaterialSetMapping = db.Table(
    "material_set_mapping",
    db.Column("SetID", db.ForeignKey(Set.SetID), primary_key=True),
    db.Column("MaterialID", db.ForeignKey(Material.MaterialID), primary_key=True),
)

MaterialRentalMapping = db.Table(
    "material_rental_mapping",
    db.Column("RentalID", db.ForeignKey(Rental.RentalID), primary_key=True),
    db.Column("MaterialID", db.ForeignKey(Material.MaterialID), primary_key=True),
)

RentalReturnMapping = db.Table(
    "rental_return_mapping",
    db.Column("RentalID", db.ForeignKey(Rental.RentalID), primary_key=True),
    db.Column("ReturnID", db.ForeignKey(Return.ReturnID), primary_key=True),
)
