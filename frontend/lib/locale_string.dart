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
      'hide_password': 'Hide password',
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
      'email_not_valid': 'Email is not valid',
      'name_is_mandatory': 'Name is mandatory',
      'name_not_valid': 'Name not valid',
      'street_is_mandatory': 'street name is mandatory',
      'street_not_valid': 'Street name not valid',
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
      'permissions': 'Permissions',
      'summary': 'Summary',
      'shopping_cart': 'Shopping Cart',
      'checkout': 'Checkout',
      'total_price': 'Total Price',
      'rental_period': 'Rental Period',
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
      'success': 'Success',
      'signup_successful': 'Signup successful. A verification e-mail has been sent to you',
      'error': 'Error',
      'unknown_error_occurred': 'An Unknown Error occurred',
      'network_error': 'Network Error',
      'network_error_occurred': 'A Network Error occurred',
      'edit_user': 'Edit User',
      'usage_start_must_be_after_rental_start': 'Usage start must be after rental start',
      'usage_end_must_be_before_rental_end': 'Usage end must be before rental end',
      'reservation_completed': 'Reservation completed',
      'inspect': 'Inspect',
      'confirm': 'Confirm',
      'total': 'Total',
      'completed': 'Completed',
      'no_items_assigned_to_this_rental_entry': 'No items assigned to this rental entry',
      'condition': 'Condition',
      'ok': 'Okay',
      'broken': 'Broken',
      'add_item': 'Add Item',
      'next_inspection': 'Next Inspection',
      'product_details': 'Product Details',
      'installation': 'Installation',
      'usage_in_days': 'Usage in Days',
      'rental_fee': 'Rental Fee',
      'profile': 'Profile',
      'email_is_mandatory': 'Email is mandatory',
      'order_history': 'Order History',
      'cancel': 'Cancel',
      'cancel_reservation': 'Cancel Reservation',
      'logout': 'Logout',
      'inspection_details': 'Inspection Details',
      'comment': 'Comment',
      'inspection_date': 'Inspection Date',
      'inspector': 'Inspector',
      'add_inspection': 'Add Inspection',
      'login_notice': 'Please login to continue',
      'purchase_date' : 'Purchase Date',
      'invoice_number' : 'Invoice No.',
      'merchant' : 'Merchant',
      'production_date' : 'Production Date',
      'purchase_price' : 'Purchase Price',
      'suggested_retail_price' : 'Suggested Retail Price',
      'manufacturer' : 'Manufacturer',
      'inventory_number' : 'Inventory No.',
      'max_operating_date' : 'Max. Operational Lifetime',
      'max_days_used' : 'Max. Usage in Days',
      'instructions' : 'Instructions',
      'no_image_found': 'No Image Found',
      'repair': 'Repair',
      'extras': 'Extras',
      'export_inventory_to_csv': 'Export inventory to CSV',
      'export': 'Export',
    },
    'de_DE': {
      'hello': 'Hallo',
      'login': 'Anmelden',
      'email': 'E-Mail',
      'password': 'Passwort',
      'show_password': 'Passwort anzeigen',
      'hide_password': 'Passwort verstecken',
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
      'permissions': 'Berechtigungen',
      'summary': 'Überblick',
      'shopping_cart': 'Warenkorb',
      'checkout': 'Zur Kasse',
      'total_price': 'Gesamtpreis',
      'rental_period': 'Leihdauer',
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
      'success': 'Erfolg',
      'signup_successful': 'Registrierung erfolgreich. Es wurde eine Bestätigungs-E-Mail an dich geschickt',
      'error': 'Fehler',
      'unknown_error_occurred': 'Ein unbekannter Fehler ist aufgetreten',
      'network_error': 'Netzwerkfehler',
      'network_error_occurred': 'Ein Netzwerkfehler ist aufgetreten',
      'edit_user': 'Benutzer bearbeiten',
      'usage_start_must_be_after_rental_start': 'Nutzungsbeginn muss nach Leihbeginn liegen',
      'usage_end_must_be_before_rental_end': 'Nutzungsende muss vor Leihende liegen',
      'reservation_completed': 'Reservierung abgeschlossen',
      'inspect': 'Prüfen',
      'confirm': 'Bestätigen',
      'total': 'Gesamt',
      'completed': 'Abgeschlossen',
      'no_items_assigned_to_this_rental_entry': 'Keine Artikel zu dieser Leihbuchung zugeordnet',
      'condition': 'Zustand',
      'ok': 'Okay',
      'broken': 'Defekt',
      'add_item': 'Gegenstand hinzufügen',
      'next_inspection': 'Nächste Prüfung',
      'product_details': 'Produktdetails',
      'installation': 'Inbetriebnahme',
      'usage_in_days': 'Nutzungsdauer in Tagen',
      'rental_fee': 'Verleihgebühr',
      'profile': 'Profil',
      'email_is_mandatory': 'Email ist verplichtend',
      'order_history': 'Bestellverlauf',
      'cancel': 'Stornieren',
      'cancel_order': 'Bestellung stornieren',
      'logout': 'Abmelden',
      'inspection_details': 'Prüfungsdetails',
      'comment': 'Kommentar',
      'inspection_date': 'Inspektions Datum',
      'inspector': 'Inspektor',
      'add_inspection': 'Neue Inspektion',
      'login_notice': 'Bitte anmelden, um fortzufahren',
      'purchase_date' : 'Kaufdatum',
      'invoice_number' : 'Rechnungsnr.',
      'merchant' : 'Händler',
      'production_date' : 'Produktionsdatum',
      'purchase_price' : 'Kaufpreis',
      'suggested_retail_price' : 'Unverbindliche Preisempfehlung',
      'manufacturer' : 'Hersteller',
      'inventory_number' : 'Inventarnr.',
      'max_operating_date' : 'Max. Lebensdauer',
      'max_days_used' : 'Max. Gebrauchsdauer in Tagen',
      'instructions' : 'Gebrauchsanweisung',
      'no_image_found': 'Kein Bild gefunden',
      'repair': 'Reparatur',
      'extras': 'Extras',
      'export_inventory_to_csv': 'Inventar zu CSV exportieren',
      'export': 'Exportieren',
    }
  };
}
