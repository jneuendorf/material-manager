class UserModel {
  final int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String membershipNumber;
  Address address;
  String? category;
  List<Role> roles;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.membershipNumber,
    required this.address,
    required this.roles,
    this.category,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    email: json['email'],
    phone: json['phone'],
    membershipNumber: json['membership_number'],
    address: Address(
      street: json['street'],
      houseNumber: json['house_number'],
      city: json['city'],
      zip: json['zip'],
    ),
    category: json['category'],
    roles: List<Role>.from(json['roles'].map((x) => Role.fromJson(x))),
  );
}


class Address {
  String street;
  String houseNumber;
  String city;
  String zip;

  Address({
    required this.street,
    required this.houseNumber,
    required this.city,
    required this.zip,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    street: json['street'],
    houseNumber: json['houseNumber'],
    city: json['city'],
    zip: json['zip'],
  );
}



class Role {
  final int? id;
  String name;
  String description;
  List<Permission> permissions;

  Role({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    permissions: List<Permission>.from(json['permissions'].map((x) => Permission.fromJson(x))),
  );
}


class Permission {
  final int id;
  String name;
  String description;

  Permission({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
    id: json['id'],
    name: json['name'],
    description: json['description'],
  );
}
