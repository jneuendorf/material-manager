import 'package:frontend/common/core/models.dart';
import 'package:frontend/extensions/user/model.dart';


final ImprintModel mockImprint = ImprintModel(
  clubName: 'Deutscher Alpenverein Sektion Berlin e.V.',
  address: Address(
    street: 'Musterstraße',
    houseNumber: '56A',
    zip: '12553',
    city: 'Berlin',
  ),
  phoneNumber: '+49 12345678942',
  email: 'muster@mail.com',
  boardMembers: ['Peter Müller (Vorsitzender)','Hans Meyer (Stellvertreter)'],
  registrationNumber: 7235,
  registryCourt: 'Amtgericht Berlin',
  vatNumber: '1234 567 89',
  disputeResolutionURI: Uri.parse('http://ec.europa.eu/consumers/odr/'),
);
