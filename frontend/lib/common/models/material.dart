
class MaterialModel {
  final int id;
  List<SerialNumber> serialNumbers;
  String inventoryNumber;
  String maxLifeExpectancy;
  String maxServiceDuration;
  DateTime installationDate;
  String instructions;
  DateTime nextInspectionDate;
  double rentalFee;
  Condition condition;
  int usage;
  PurchaseDetails purchaseDetails;
  List<Property> properties;
  List<EquipmentType> equipmentTypes;


  MaterialModel({
    required this.id,
    required this.serialNumbers,
    required this.inventoryNumber,
    required this.maxLifeExpectancy,
    required this.maxServiceDuration,
    required this.installationDate,
    required this.instructions,
    required this.nextInspectionDate,
    required this.rentalFee,
    required this.condition,
    required this.usage,
    required this.purchaseDetails,
    required this.properties,
    required this.equipmentTypes,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) => MaterialModel(
    id: json['id'],
    serialNumbers: List<SerialNumber>.from(json['serialNumbers'].map((x) => SerialNumber.fromJson(x))),
    inventoryNumber: json['inventoryNumber'],
    maxLifeExpectancy: json['maxLifeExpectancy'],
    maxServiceDuration: json['maxServiceDuration'],
    installationDate: DateTime.parse(json['installationDate']),
    instructions: json['instructions'],
    nextInspectionDate: DateTime.parse(json['nextInspectionDate']),
    rentalFee: json['rentalFee'],
    condition: Condition.values.byName(json['condition']),
    usage: json['usage'],
    purchaseDetails: PurchaseDetails.fromJson(json['purchaseDetails']),
    properties: List<Property>.from(json['properties'].map((x) => Property.fromJson(x))),
    equipmentTypes: List<EquipmentType>.from(json['equipmentTypes'].map((x) => EquipmentType.fromJson(x))),
  );
}

class SerialNumber {
  final int id;
  String manufacturer;

  SerialNumber({
    required this.id,
    required this.manufacturer,
  });

  factory SerialNumber.fromJson(Map<String, dynamic> json) => SerialNumber(
    id: json['id'],
    manufacturer: json['manufacturer'],
  );
}

enum Condition {
  good,
  broken,
}

class PurchaseDetails {
  final int id;
  DateTime purchaseDate;
  String invoiceNumber;
  String merchant;
  DateTime productionDate;
  double purchasePrice;
  double suggestedRetailPrice;

  PurchaseDetails({
    required this.id,
    required this.purchaseDate,
    required this.invoiceNumber,
    required this.merchant,
    required this.productionDate,
    required this.purchasePrice,
    required this.suggestedRetailPrice,
  });

  factory PurchaseDetails.fromJson(Map<String, dynamic> json) => PurchaseDetails(
    id: json['id'],
    purchaseDate: DateTime.parse(json['purchaseDate']),
    invoiceNumber: json['invoiceNumber'],
    merchant: json['merchant'],
    productionDate: DateTime.parse(json['productionDate']),
    purchasePrice: json['purchasePrice'],
    suggestedRetailPrice: json['suggestedRetailPrice'],
  );
}

class Property {
  final int id;
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

  factory Property.fromJson(Map<String, dynamic> json) => Property(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    value: json['value'],
    unit: json['unit'],
  );
}

class EquipmentType {
  final int id;
  String description;

  EquipmentType({
    required this.id,
    required this.description,
  });

  factory EquipmentType.fromJson(Map<String, dynamic> json) => EquipmentType(
    id: json['id'],
    description: json['description'],
  );
}
