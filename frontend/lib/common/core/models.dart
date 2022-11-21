import 'package:frontend/extensions/user/model.dart';


class ImprintModel {
  String clubName;
  Address address;
  String phoneNumber;
  String email;
  List<BoardMember> boardMembers;
  int registrationNumber;
  String registryCourt;
  String vatNumber;

  ImprintModel({
    required this.clubName, 
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.boardMembers,
    required this.registrationNumber,
    required this.registryCourt,
    required this.vatNumber,
  });

  factory ImprintModel.fromJson(Map<String, dynamic> json) {
    return ImprintModel(
      clubName: json['club_name'],
      address: Address.fromJson(json['address']),
      phoneNumber: json['phone_number'],
      email: json['email'],
      boardMembers: List<BoardMember>.from(json['board_members'].map((x) => BoardMember.fromJson(x))),
      registrationNumber: json['registration_number'],
      registryCourt: json['registry_court'],
      vatNumber: json['vat_number'],
    );
  }
}

class BoardMember {
  String firstName;
  String lastName;

  BoardMember({
    required this.firstName,
    required this.lastName,
  });

  factory BoardMember.fromJson(Map<String, dynamic> json) {
    return BoardMember(
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}