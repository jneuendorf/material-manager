import 'package:frontend/extensions/user/model.dart';


class ImprintModel {
  String clubName;
  Address address;
  String phoneNumber;
  String email;
  List<String> boardMembers;
  int registrationNumber;
  String registryCourt;
  String vatNumber;
  Uri disputeResolutionURI;

  ImprintModel({
    required this.clubName, 
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.boardMembers,
    required this.registrationNumber,
    required this.registryCourt,
    required this.vatNumber,
    required this.disputeResolutionURI,
  });

  factory ImprintModel.fromJson(Map<String, dynamic> json) {
    return ImprintModel(
      clubName: json['club_name'],
      address: Address.fromJson(json['address']),
      phoneNumber: json['phone_number'],
      email: json['email'],
      boardMembers: json['board_members'] != null ? List<String>.from(json['board_members']) : [],
      registrationNumber: json['registration_number'],
      registryCourt: json['registry_court'],
      vatNumber: json['vat_number'],
      disputeResolutionURI: Uri.parse(json['dispute_resolution_uri']),
    );
  }
}

class PrivacyPolicyModel {
  String company;
  String firstName;
  String lastName;
  Address address;
  String phoneNumber;
  String email;

  PrivacyPolicyModel(
    {
      required this.company,
      required this.firstName,
      required this.lastName,
      required this.address,
      required this.phoneNumber,
      required this.email,
    }
  );

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      company: json['company'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      address: Address.fromJson(json['address']),
      phoneNumber: json['phone_number'],
      email: json['email'],
    );
  }
}

class NonFinalMapEntry<K,V> {
  K key;
  V value;

  NonFinalMapEntry(this.key, this.value);
}
