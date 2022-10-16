
class User {
  final int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  int membershipNumber;
  Address address;
  List<Role> roles;
  String? category;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    email: json['email'],
    phone: json['phone'],
    membershipNumber: json['membershipNumber'],
    address: Address.fromJson(json['address']),
    roles: List<Role>.from(json['roles'].map((x) => Role.fromJson(x))),
    category: json['category'],
  );
}

class Address {
  String street;
  int houseNumber;
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
  final int id;
  String name;
  String description;
  List<Right> rights;

  Role({
    required this.id,
    required this.name,
    required this.description,
    required this.rights,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    rights: List<Right>.from(json['rights'].map((x) => Right.fromJson(x))),
  );
}

class Right {
  final int id;
  String name;
  String description;

  Right({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Right.fromJson(Map<String, dynamic> json) => Right(
    id: json['id'],
    name: json['name'],
    description: json['description'],
  );
}
