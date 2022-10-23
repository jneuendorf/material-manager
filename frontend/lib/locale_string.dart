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
      'imprint': 'Imprint',
      'privacy_policy': 'Privacy Policy',
      'links': 'Links',
      'other': 'Other',
      'remember_me': 'Remember me',
      'signup': 'Sign up',
      'single_material': 'Single Material',
      'sets': 'Sets',
      'items': 'Items',
      'search': 'Search',
      'type': 'Type',
      'all': 'All',
      'membership_number': 'Membership No.',
      'first_name': 'First Name',
      'last_name': 'Last Name',
      'street_name': 'Street name',
      'house_number': 'Housenumber',
      'city': 'City',
      'zip': 'ZIP',
      'next': 'Next',
      'phone': 'Phone Number',
      'confirm_password': 'Confirm Password',
      'membership_num_is_mandatory': 'Membership number is mandatory',
      'invalid_membership_num': 'invalid membership number',
      'Email_not_valid': 'Email is not valid',
      'name_is_mandatory': 'Name is mandatory',
      'name_not_valid': 'Name not valid',
      'street_is_mandatory': 'street name is mandatory',
      'street_not_valid': 'Streetname not valid',
      'housenumber_is_mandatory': 'Housenumber is mandatory',
      'city_is_mandatory': 'City is mandatory',
      'city_not_valid': 'City not valid',
      'zip_is_mandatory': 'Zip is mandatory',
      'zip_not_valid': 'Zip not valid',
      'phone_not_valid': 'Phone number not valid',
      'password_is_mandatory':'Password is mandatory',
      'passwords_not_equal': 'Passwords do not match',
      'accounts': 'Accounts',
      'roles': 'Roles',
      'name': 'Name',
      'role': 'Role',
      'description': 'Description',
      'rights': 'Rights',
      'summary': 'Summary',
      'shopping_cart': 'Shopping Cart',
      'checkout': 'Checkout',
      'total_price': 'Total Price',
      'retal_period': 'Rental Period',
      'usage_period': 'Usage Period',
      'enter_start_date': 'Enter Start Date',
      'enter_end_date': 'Enter End Date',
      'date_is_mandatory': 'Date is mandatory',
      'back_to_selection': 'Back to Selection',
      'remove': 'Remove',
      'shopping_cart_is_empty': 'Shopping Cart is empty!',
      'active_orders': 'Active Orders',
      'completed_orders': 'Completed Orders',
      'order_number': 'Order No.',
      'price': 'Price',
      'order_date': 'Order date',
      'status': 'Status',
      'add_role': 'Add Role',
      'add_user': 'Add User',
      'account_details': 'Account Details',
      'edit_profile': 'Edit Profile',
      'add': 'Add',
      'description_is_mandatory': 'Description is mandatory',
      'error': 'Error',
      'unknown_error_occured': 'An Unknown Error occured',
      'network_error': 'Network Error',
      'network_error_occured': 'A Network Error occured',
      'edit_user': 'Edit User',
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
      'imprint': 'Impressum',
      'privacy_policy': 'Datenschutzerklärung',
      'links': 'Links',
      'other': 'Andere',
      'remember_me': 'Angemeldet bleiben',
      'signup': 'Registrieren',
      'single_material': 'Einzelmaterial',
      'sets': 'Sets',
      'items': 'Artikel',
      'search': 'Suchen',
      'type': 'Art',
      'all': 'Alle',
      'membership_number': 'Mitgliedsnr.',
      'first_name': 'Vorname',
      'last_name': 'Nachname',
      'street_name': 'Straßenname',
      'house_number': 'Hausnummer',
      'city': 'Stadt',
      'zip': 'PLZ.',
      'next': 'Weiter',
      'phone': 'Telefonnummer',
      'confirm_password': 'Passwort bestätigen',
      'membership_num_is_mandatory': 'Mitgliednummer ist verplichtend',
      'invalid_membership_num': 'ungültige Mitgliednummer',
      'email_not_valid': 'Email ist nicht Gültig',
      'name_is_mandatory': 'Ein Name ist verplichtend',
      'name_not_valid': 'Name ist nicht Gültig',
      'street_is_mandatory': 'Straßenname ist verplichtend',
      'street_not_valid': 'Strassenname ist nicht Gültig',
      'housenumber_is_mandatory': 'Hausnummer ist verplichtend',
      'zip_is_mandatory': 'PLZ ist verplichtend',
      'zip_not_valid': 'PLZ ist nicht Gültig',
      'phone_not_valid': 'Telefonnummer ist nicht Gültig',
      'password_is_mandatory':'Passwort ist verplichtend',
      'passwords_not_equal': 'Passwörter stimmen nicht überein',
      'accounts': 'Accounts',
      'roles': 'Rollen',
      'name': 'Name',
      'role': 'Rolle',
      'description': 'Beschreibung',
      'rights': 'Berechtigungen',
      'summary': 'Überblick',
      'shopping_cart': 'Warenkorb',
      'checkout': 'Zur Kasse',
      'total_price': 'Gesamtpreis',
      'retal_period': 'Leihdauer',
      'usage_period': 'Nutzungsdauer',
      'enter_start_date': 'Startdatum eingeben',
      'enter_end_date': 'Enddatum eingeben',
      'date_is_mandatory': 'Datum ist verplichtend',
      'back_to_selection': 'Zurück zur Auswahl',
      'remove': 'Entfernen',
      'shopping_cart_is_empty': 'Warenkorb ist leer!',
      'active_orders': 'Active Bestellungen',
      'completed_orders': 'Abgeschlossene Bestellungen',
      'order_number': 'Bestellnr.',
      'price': 'Preis',
      'order_date': 'Bestell Datum',
      'status': 'Status',
      'add_role': 'Rolle hinzufügen',
      'add_user': 'Benutzer hinzufügen',
      'account_details': 'Account Details',
      'edit_profile': 'Profil bearbeiten',
      'add': 'Hinzufügen',
      'description_is_mandatory': 'Beschreibung ist verplichtend',
      'error': 'Fehler',
      'unknown_error_occured': 'Ein unbekannter Fehler ist aufgetreten',
      'network_error': 'Netzwerkfehler',
      'network_error_occured': 'Ein Netzwerkfehler ist aufgetreten',
      'edit_user': 'Benutzer bearbeiten',
    }
  };
}
