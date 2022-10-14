import 'package:get/get.dart';

class LocaleString extends Translations {

    @override
    Map<String, Map<String, String>> get keys => {
    'en_US': {
      'hello': 'Hello',
      'login': 'Login',
      'email': 'Email',
      'password': 'Password',
      'show_password': 'Show password',
      'administration': 'Administration',
      'inspection': 'Inspection',
      'inventory': 'Inventory',
      'lender': 'Lender',
      'rental': 'Rental',
    },
    'de_DE': {
      'hello': 'Hallo',
      'login': 'Anmelden',
      'email': 'E-Mail',
      'password': 'Passwort',
      'show_password': 'Passwort anzeigen',
      'administration': 'Verwaltung',
      'inspection': 'Inspektion',
      'inventory': 'Inventar',
      'lender': 'Ausleiher',
      'rental': 'Verleih',
    }
  };
}
