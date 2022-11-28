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
      'member_number': 'Member No.',
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
      'remove_property': 'Remove Property',
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
      // For material
      'images': 'Bilder',
      'serial_numbers': 'Serial No.',
      'inventory_number' : 'Inventory No.',
      'max_operating_date' : 'Max. Operational Lifetime',
      'max_days_used' : 'Max. Usage in Days',
      'installation': 'Installation',
      'instructions' : 'Instructions',
      'next_inspection': 'Next Inspection',
      'rental_fee': 'Rental Fee',
      'condition': 'Condition',
      'ok': 'Okay',
      'broken': 'Broken',
      'repair': 'Repair',
      'days_used': 'Usage in Days',
      'purchase_date' : 'Purchase Date',
      'invoice_number' : 'Invoice No.',
      'merchant' : 'Merchant',
      'production_date' : 'Production Date',
      'purchase_price' : 'Purchase Price',
      'suggested_retail_price' : 'Suggested Retail Price',
      'manufacturer' : 'Manufacturer',
      'properties': 'Properties',
      //
      'add_item': 'Add Item',
      'product_details': 'Product Details',
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
      'max_life_expectancy' : 'Max. Life Expectancy',
      'max_service_duration' : 'Max. Service Duration',
      'value': 'Value',
      'unit': 'Unit',
      'add_property': 'Add Property',
      'add_serial_number': 'Add Serial-num.',
      'serial_number': 'SerialNo.',
      'no_image_found': 'No Image Found',
      'extras': 'Extras',
      'export_inventory_to_csv': 'Export inventory to CSV',
      'export': 'Export',
      'edit': 'Edit',
      'general': 'General',
      'address': 'Address',
      'serial_num_is_mandatory': 'Serialnumber is Mandatory',
      'production_date_is_mandatory': 'Production Date is Mandatory',
      'inventory_number_is_mandatory': 'Inventory Number is Mandatory',
      'unequal_serialNumbers_and_production_dates': 'Unequal Serial Numbers And Production Dates',
      'not_enough_serial_numbers': 'Not Enough Serial Numbers',
      'not_enough_production_dates': 'Not Enough Production Dates',
      'edit_imprint': 'Edit Imprint',
      'club_name': 'Club Name',
      'club_name_is_mandatory': 'Club Name is mandatory',
      'vat_number': 'VAT Number',
      'vat_number_is_mandatory': 'VAT Number is mandatory',
      'registration_number': 'Registration Number',
      'registration_number_is_mandatory': 'Registration Number is mandatory',
      'registry_court': 'Registry Court',
      'registry_court_is_mandatory': 'Registry Court is mandatory',
      'add_board_member': 'Add Board Member',
      'board_member': 'Board Member',
      'board_member_is_mandatory': 'Board Member is mandatory',
      'material_type': 'Material Type',
      'material_type_is_mandatory': 'Material Type is mandatory',
      'rental_fee_is_mandatory': 'Rental Fee is mandatory',
      'rental_fee_must_be_a_number': 'Rental Fee must be a number',
      'max_life_expectancy_is_mandatory': 'Max. Life Expectancy is mandatory',
      'max_life_expectancy_must_be_a_number': 'Max. Life Expectancy must be a number',
      'max_service_duration_is_mandatory': 'Max. Service Duration is mandatory',
      'max_service_duration_must_be_a_number': 'Max. Service Duration must be a number',
      'instructions_are_mandatory': 'Instructions are mandatory',
      'next_inspection_is_mandatory': 'Next Inspection is mandatory',
      'next_inspection_must_be_a_number': 'Next Inspection must be a number',
      'purchase_date_is_mandatory': 'Purchase Date is mandatory',
      'merchant_is_mandatory': 'Merchant is mandatory',
      'purchase_price_is_mandatory': 'Purchase Price is mandatory',
      'purchase_price_must_be_a_number': 'Purchase Price must be a number',
      'invoice_number_is_mandatory': 'Invoice Number is mandatory',
      'manufacturer_is_mandatory': 'Manufacturer is mandatory',
      'suggested_retail_price_is_mandatory': 'Suggested Retail Price is mandatory',
      'suggested_retail_price_must_be_a_number': 'Suggested Retail Price must be a number',
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
      'member_number': 'Mitg.Nr.',
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
      'email_not_valid': 'Email ist nicht gültig',
      'name_is_mandatory': 'Ein Name ist verplichtend',
      'name_not_valid': 'Name ist nicht gültig',
      'street_is_mandatory': 'Straßenname ist verplichtend',
      'street_not_valid': 'Strassenname ist nicht gültig',
      'housenumber_is_mandatory': 'Hausnummer ist verplichtend',
      'zip_is_mandatory': 'PLZ ist verplichtend',
      'zip_not_valid': 'PLZ ist nicht gültig',
      'phone_not_valid': 'Telefonnummer ist nicht gültig',
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
      'remove_property': 'Eigenschaft entfernen',
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
      // Für Material
      'images': 'Bilder',
      'serial_numbers': 'SerienNr.',
      'inventory_number' : 'Inventarnr.',
      'max_operating_date' : 'Max. Lebensdauer',
      'max_days_used' : 'Max. Gebrauchsdauer in Tagen',
      'installation': 'Inbetriebnahme',
      'instructions' : 'Gebrauchsanweisung',
      'next_inspection': 'Nächste Prüfung',
      'rental_fee': 'Verleihgebühr',
      'condition': 'Zustand',
      'ok': 'Okay',
      'broken': 'Defekt',
      'repair': 'Reparatur',
      'days_used': 'Nutzungsdauer in Tagen',
      'purchase_date' : 'Kaufdatum',
      'invoice_number' : 'Rechnungsnr.',
      'merchant' : 'Händler',
      'production_date' : 'Produktionsdatum',
      'purchase_price' : 'Kaufpreis',
      'suggested_retail_price' : 'Unverbindliche Preisempfehlung',
      'manufacturer' : 'Hersteller',
      'properties': 'Eigenschaften',
      //
      'add_item': 'Gegenstand hinzufügen',
      'product_details': 'Produktdetails',
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
      'max_life_expectancy' : 'Max. Lebenserwartung',
      'max_service_duration' : 'Max. Dienstdauer',
      'value': 'Wert',
      'unit': 'Einheit',
      'add_property': 'Eigenschaft hinzufügen',
      'add_serial_number': 'Seriennum. hinzufügen',
      'serial_number': 'Seriennummer',
      'no_image_found': 'Kein Bild gefunden',
      'extras': 'Extras',
      'export_inventory_to_csv': 'Inventar zu CSV exportieren',
      'export': 'Exportieren',
      'edit' : 'Bearbeiten',
      'general': 'Allgemein',
      'address': 'Adresse',
      'serial_num_is_mandatory': 'Serialnum. ist verplichtend',
      'production_date_is_mandatory': 'Produktionsdatum ist verplichtend',
      'inventory_number_is_mandatory': 'Inventarnummer ist verplichtend',
      'unequal_serialNumbers_and_production_dates': 'Ungleiche Anzahl an Seriennummern und Productionsdaten',
      'not_enough_serial_numbers' : 'Nicht genügend Seriennummern',
      'not_enough_production_dates': 'Nicht genügend Produktionsdaten',
      'edit_imprint': 'Impressum bearbeiten',
      'club_name': 'Vereinsname',
      'club_name_is_mandatory': 'Vereinsname ist verplichtend',
      'vat_number': 'USt-IdNr.',
      'vat_number_is_mandatory': 'USt-IdNr. ist verplichtend',
      'registration_number': 'Registernummer',
      'registration_number_is_mandatory': 'Registernummer ist verplichtend',
      'registry_court': 'Registergericht',
      'registry_court_is_mandatory': 'Registergericht ist verplichtend',
      'add_board_member': 'Vorstandsmitglied hinzufügen',
      'board_member': 'Vorstandsmitglied',
      'board_member_is_mandatory': 'Vorstandsmitglied ist verplichtend',
      'material_type': 'Materialtyp', 
      'material_type_is_mandatory': 'Materialtyp ist verplichtend',
      'rental_fee_is_mandatory': 'Verleihgebühr ist verplichtend',
      'rental_fee_must_be_a_number': 'Verleihgebühr muss eine Zahl sein',
      'max_life_expectancy_is_mandatory': 'Max. Lebenserwartung ist verplichtend',
      'max_life_expectancy_must_be_a_number': 'Max. Lebenserwartung muss eine Zahl sein',
      'max_service_duration_is_mandatory': 'Max. Dienstdauer ist verplichtend',
      'max_service_duration_must_be_a_number': 'Max. Dienstdauer muss eine Zahl sein',
      'instructions_are_mandatory': 'Gebrauchsanweisung ist verplichtend',
      'next_inspection_is_mandatory': 'Nächste Inspektion ist verplichtend',
      'next_inspection_must_be_a_number': 'Nächste Inspektion muss eine Zahl sein',
      'purchase_date_is_mandatory': 'Kaufdatum ist verplichtend',
      'merchant_is_mandatory': 'Händler ist verplichtend',
      'purchase_price_is_mandatory': 'Kaufpreis ist verplichtend',
      'purchase_price_must_be_a_number': 'Kaufpreis muss eine Zahl sein',
      'invoice_number_is_mandatory': 'Rechnungsnr. ist verplichtend',
      'manufacturer_is_mandatory': 'Hersteller ist verplichtend',
      'suggested_retail_price_is_mandatory': 'UVP ist verplichtend',
      'suggested_retail_price_must_be_a_number': 'UVP muss eine Zahl sein',
    }
  };
}
