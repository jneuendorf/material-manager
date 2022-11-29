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

//mock data
final ImprintModel mockImprint = ImprintModel(
  clubName: 'Deutscher Alpenverein Sektion Berlin e.V.',
  address: Address(street:'Musterstraße' ,houseNumber:'56A',zip:'12553' ,city:'Berlin'),
  phoneNumber: '+49 12345678942',
  email: 'muster@mail.com',
  boardMembers: ['Peter Müller','Hans Meyer'],
  registrationNumber: 7235183613,
  registryCourt: 'Amtgericht Berlin',
  vatNumber: '1234 567 89'
);
