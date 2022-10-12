# from dav_material.db import db
#
# # create_all() turns each class into a table
# # UserRole class name will be auto-renamed user_role in the DB
#
# # tables without foreign key
#
#
# class Set(db.Model):
#     SetID = db.Column(db.Integer, primary_key=True)
#     Name = db.Column(db.String)
#     Description = db.Column(db.String)
#
#
# class RentalStatus(db.Model):
#     RentalStatusID = db.Column(db.Integer, primary_key=True)
#     Name = db.Column(db.String)
#
#
# # tables with foreign key
#
#
# class Return(db.Model):
#     ReturnID = db.Column(db.Integer, primary_key=True)
#     Comment = db.Column(db.String)
#     Photo = db.Column(db.String)
#     MaterialID = db.Column(db.ForeignKey(Material.MaterialID))
#
#
# class Rental(db.Model):
#     RentalID = db.Column(db.Integer, primary_key=True)
#     CustomerID = db.Column(db.ForeignKey(User.UserID))
#     LenderID = db.Column(db.ForeignKey(User.UserID))
#     TotalAmount = db.Column(db.Integer)
#     RentalStatusID = db.Column(db.ForeignKey(RentalStatus.RentalStatusID))
#     Date = db.Column(db.Integer)
#     RentalDuration = db.Column(db.Integer)
#     UsageDuration = db.Column(db.Integer)
#     ReturnToID = db.Column(db.ForeignKey(User.UserID))
#     Deposit = db.Column(db.Integer)
#
#
# class PSAInspection(db.Model):
#     PSAID = db.Column(db.Integer, primary_key=True)
#     InspectorID = db.Column(db.ForeignKey(User.UserID))
#     Date = db.Column(db.String)
#     Status = db.Column(db.String)
#     RentalID = db.Column(db.ForeignKey(Rental.RentalID))
#
#
# # tables with foreign key as primary key
#
#
# class PSAComment(db.Model):
#     PSAID = db.Column(db.ForeignKey(PSAInspection.PSAID), primary_key=True)
#     MaterialID = db.Column(db.ForeignKey(Material.MaterialID), primary_key=True)
#     Comment = db.Column(db.String)
#     Photo = db.Column(db.String)
#
#
# class Customer(db.Model):
#     UserID = db.Column(db.ForeignKey(User.UserID), primary_key=True)
#     FirsName = db.Column(db.String)
#     LastName = db.Column(db.String)
#     Email = db.Column(db.String)
#     Phone = db.Column(db.String)
#     Address1 = db.Column(db.String)
#     Address2 = db.Column(db.String)
#     Category = db.Column(db.String)
#
#
# # mapping tables m2m
# # source: https://flask-sqlalchemy.palletsprojects.com/en/3.0.x/models/
#
# MaterialSetMapping = db.Table(
#     "material_set_mapping",
#     db.Column("SetID", db.ForeignKey(Set.SetID), primary_key=True),
#     db.Column("MaterialID", db.ForeignKey(Material.MaterialID), primary_key=True),
# )
#
# MaterialRentalMapping = db.Table(
#     "material_rental_mapping",
#     db.Column("RentalID", db.ForeignKey(Rental.RentalID), primary_key=True),
#     db.Column("MaterialID", db.ForeignKey(Material.MaterialID), primary_key=True),
# )
#
# RentalReturnMapping = db.Table(
#     "rental_return_mapping",
#     db.Column("RentalID", db.ForeignKey(Rental.RentalID), primary_key=True),
#     db.Column("ReturnID", db.ForeignKey(Return.ReturnID), primary_key=True),
# )
