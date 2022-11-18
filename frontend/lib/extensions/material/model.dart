import 'package:csv/csv.dart';
import 'package:get/get.dart';

const csvEncoder = ListToCsvConverter();

class MaterialModel {
  final int? id;
  List<String> imageUrls;
  List<SerialNumber> serialNumbers;
  String inventoryNumber;
  DateTime maxOperatingDate;
  int maxDaysUsed;
  DateTime installationDate;
  String instructions;
  DateTime nextInspectionDate;
  double rentalFee;
  ConditionModel condition;
  int daysUsed;
  PurchaseDetails purchaseDetails;
  List<Property> properties;
  MaterialTypeModel materialType;


  MaterialModel({
    required this.id,
    required this.imageUrls,
    required this.serialNumbers,
    required this.inventoryNumber,
    required this.maxOperatingDate,
    required this.maxDaysUsed,
    required this.installationDate,
    required this.instructions,
    required this.nextInspectionDate,
    required this.rentalFee,
    required this.condition,
    required this.daysUsed,
    required this.purchaseDetails,
    required this.properties,
    required this.materialType,
  });

  MaterialModel.fromJson(Map<String, dynamic> json):
    id = json['id'],
    imageUrls = json['image_urls'] != null ? List<String>.from(json['image_urls']) : [],
    serialNumbers = List<SerialNumber>.from(json['serial_numbers'].map((x) => SerialNumber.fromJson(x))),
    inventoryNumber = json['inventory_number'],
    maxOperatingDate = DateTime.parse(json['max_operating_date']),
    maxDaysUsed = json['max_days_used'],
    installationDate = DateTime.parse(json['installation_date']),
    instructions = json['instructions'],
    nextInspectionDate = DateTime.parse(json['next_inspection_date']),
    rentalFee = json['rental_fee'],
    condition = ConditionModel.values.byName(json['condition'].toLowerCase()),
    daysUsed = json['days_used'],
    purchaseDetails = PurchaseDetails.fromJson(json['purchase_details']),
    properties = List<Property>.from(json['properties'].map((x) => Property.fromJson(x))),
    materialType = MaterialTypeModel.fromJson(json['material_type']);

  List<dynamic> toCsvRow() => [
    id, imageUrls.toString(), serialNumbers.toString(), inventoryNumber, maxOperatingDate, maxDaysUsed, installationDate, instructions, nextInspectionDate, 
    rentalFee, condition.name.tr, daysUsed, purchaseDetails.toString(), properties.toString(), materialType.toString() 
  ];
}

extension CSVList on List<MaterialModel> {
  String toCSV() {
    // TODO: Purchase details (entweder eigene Spalte (mit eigenem .tr) oder Aufspalten in Einzelbestandteile)
    // TODO: Einheit fehlt für rental fee und andere Preise (sollten wir wirklich davon ausgehen, 
    //  dass das Euro (€) sind -> würde unsere i18 Bemühungen untermauern)
    // TODO: properties haben feste (deutsche) Namen -> sollte irgendwie auch allgemeiner gemacht werden.
    // TODO: usage_in_days ist inkonsistent mit days_used

    return csvEncoder.convert([
      [
        'ID', 'images'.tr, 'serial_numbers'.tr, 'inventory_number'.tr, 'max_operating_date'.tr, 'max_days_used'.tr, 'installation'.tr, 'instructions'.tr, 
        'next_inspection'.tr, 'rental_fee'.tr, 'condition'.tr, 'usage_in_days'.tr, 'Purchase Details', 'properties'.tr, 'type'.tr],
      for (final materialModel in this)
        materialModel.toCsvRow()
    ]);
  }
}

class SerialNumber {
  String serialNumber;
  String manufacturer;
  DateTime productionDate;

  SerialNumber({
    required this.serialNumber,
    required this.manufacturer,
    required this.productionDate,
  });

  SerialNumber.fromJson(Map<String, dynamic> json): 
    serialNumber = json['serial_number'],
    manufacturer = json['manufacturer'],
    productionDate = DateTime.parse(json['production_date']);

  @override
  String toString() => '$serialNumber@$manufacturer ($productionDate)';
}

enum ConditionModel {
  ok,
  broken,
  repair,
}

class PurchaseDetails {
  final int id;
  DateTime purchaseDate;
  String invoiceNumber;
  String merchant;
  //DateTime productionDate;
  double purchasePrice;
  double suggestedRetailPrice;

  PurchaseDetails({
    required this.id,
    required this.purchaseDate,
    required this.invoiceNumber,
    required this.merchant,
    //required this.productionDate,
    required this.purchasePrice,
    required this.suggestedRetailPrice,
  });

  PurchaseDetails.fromJson(Map<String, dynamic> json):
    id = json['id'],
    purchaseDate = DateTime.parse(json['purchase_date']),
    invoiceNumber = json['invoice_number'],
    merchant = json['merchant'],
    //productionDate = DateTime.parse(json['production_date']),
    purchasePrice = json['purchase_price'],
    suggestedRetailPrice = json['suggested_retail_price'];

  // No id
  @override
  String toString() => 'Purchase(date: $purchaseDate, invoice number: $invoiceNumber, merchant: $merchant, price: $purchasePrice, uvp: $suggestedRetailPrice)';
}

class Property {
  final int? id;
  String name;
  String description;
  String value;
  String unit;

  Property({
    required this.id,
    required this.name,
    required this.description,
    required this.value,
    required this.unit,
  });

  Property.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'],
    description = json['description'],
    value = json['value'],
    unit = json['unit'];

  // No id or description
  @override
  String toString() => '$name: $value $unit';
}

class MaterialTypeModel {
  final int? id;
  String name;
  String description;

  MaterialTypeModel({
    required this.id,
    required this.name,
    required this.description,
  });

  MaterialTypeModel.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'],
    description = json['description'];

  // no id or description
  @override
  String toString() => name;
}
