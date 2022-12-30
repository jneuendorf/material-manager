import 'package:csv/csv.dart';
import 'package:get/get.dart';


const csvEncoder = ListToCsvConverter();

class MaterialModel {
  final int? id;
  List<String> imageUrls;
  List<SerialNumber> serialNumbers;
  List<InventoryNumber> inventoryNumbers;
  DateTime maxOperatingDate;
  int maxDaysUsed;
  DateTime? installationDate;
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
    required this.inventoryNumbers,
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
    inventoryNumbers = List<InventoryNumber>.from(json['inventory_numbers'].map((x) => InventoryNumber.fromJson(x))),
    maxOperatingDate = DateTime.parse(json['max_operating_date']),
    maxDaysUsed = json['max_days_used'],
    installationDate = json['installation_date'] != null ? DateTime.parse(json['installation_date']) : null,
    instructions = json['instructions'],
    nextInspectionDate = DateTime.parse(json['next_inspection_date']),
    rentalFee = json['rental_fee'],
    condition = ConditionModel.values.byName(json['condition'].toLowerCase()),
    daysUsed = json['days_used'],
    purchaseDetails = PurchaseDetails.fromJson(json['purchase_details']),
    properties = List<Property>.from(json['properties'].map((x) => Property.fromJson(x))),
    materialType = MaterialTypeModel.fromJson(json['material_type']);

  List<dynamic> toCsvRow() => [
    id, imageUrls.toString(), serialNumbers.toString(), inventoryNumbers, maxOperatingDate, maxDaysUsed, installationDate, instructions, nextInspectionDate,
    rentalFee, condition.name.tr, daysUsed, purchaseDetails.toString(), properties.toString(), materialType.toString()
  ];
}

extension CSVList on List<MaterialModel> {
  String toCSV() {
    return csvEncoder.convert([
      [
        'ID', 'images'.tr, 'serial_numbers'.tr, 'inventory_number'.tr, 'max_operating_date'.tr, 'max_days_used'.tr, 'installation'.tr, 'instructions'.tr,
        'next_inspection'.tr, 'rental_fee'.tr, 'condition'.tr, 'days_used'.tr, 'Purchase Details', 'properties'.tr, 'type'.tr],
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

class InventoryNumber {
  final int? id;
  String inventoryNumber;

  InventoryNumber({
    required this.id,
    required this.inventoryNumber,
  });

  InventoryNumber.fromJson(Map<String, dynamic> json):
    id = json['id'],
    inventoryNumber = json['inventory_number'];
}


enum ConditionModel {
  ok,
  broken,
  repair,
  missing,
}

class PurchaseDetails {
  final int id;
  DateTime purchaseDate;
  String invoiceNumber;
  String merchant;
  double purchasePrice;
  double suggestedRetailPrice;

  PurchaseDetails({
    required this.id,
    required this.purchaseDate,
    required this.invoiceNumber,
    required this.merchant,
    required this.purchasePrice,
    required this.suggestedRetailPrice,
  });

  PurchaseDetails.fromJson(Map<String, dynamic> json):
    id = json['id'],
    purchaseDate = DateTime.parse(json['purchase_date']),
    invoiceNumber = json['invoice_number'],
    merchant = json['merchant'],
    purchasePrice = json['purchase_price'],
    suggestedRetailPrice = json['suggested_retail_price'];

  // No id
  @override
  String toString() => 'Purchase(date: $purchaseDate, invoice number: $invoiceNumber, merchant: $merchant, price: $purchasePrice, uvp: $suggestedRetailPrice)';
}

class PropertyType {
  final int? id;
  String name;
  String description;
  String unit;

  PropertyType({
    required this.id,
    required this.name,
    required this.description,
    required this.unit,
  });

  PropertyType.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'],
    description = json['description'] ?? '',
    unit = json['unit'];

  // No id or description
  @override
  String toString() => '$name: $unit';
}

class Property {
  final int? id;
  PropertyType propertyType;
  String value;

  Property({
    required this.id,
    required this.propertyType,
    required this.value,
  });

  Property.fromJson(Map<String, dynamic> json):
    id = json['id'],
    propertyType = PropertyType.fromJson(json['property_type']),
    value = json['value'];

  @override
  String toString() => '${propertyType.name}: $value ${propertyType.unit}';
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
