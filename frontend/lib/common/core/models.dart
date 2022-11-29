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
      boardMembers: json['board_members'] != null ? List<String>.from(json['board_members']) : [],
      registrationNumber: json['registration_number'],
      registryCourt: json['registry_court'],
      vatNumber: json['vat_number'],
    );
  }
}

class NonFinalMapEntry<K,V> {
  K key;
  V value;

  NonFinalMapEntry(this.key, this.value);
}
