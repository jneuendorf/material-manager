
class MaterialModel {
  final int? id;
  List<String> imageUrls;
  List<SerialNumber> serialNumbers;
  String inventoryNumber;
  String maxLifeExpectancy;
  String maxServiceDuration;
  DateTime installationDate;
  String instructions;
  DateTime nextInspectionDate;
  double rentalFee;
  ConditionModel condition;
  int usage;
  PurchaseDetails purchaseDetails;
  List<Property> properties;
  MaterialTypeModel materialType;


  MaterialModel({
    required this.id,
    required this.imageUrls,
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
    required this.materialType,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) => MaterialModel(
    id: json['id'],
    imageUrls: json['image_urls'] != null ? List<String>.from(json['image_urls']) : [],
    serialNumbers: List<SerialNumber>.from(json['serial_numbers'].map((x) => SerialNumber.fromJson(x))),
    inventoryNumber: json['inventory_number'],
    maxLifeExpectancy: json['max_life_expectancy'],
    maxServiceDuration: json['max_service_duration'],
    installationDate: DateTime.parse(json['installation_date']),
    instructions: json['instructions'],
    nextInspectionDate: DateTime.parse(json['next_inspection_date']),
    rentalFee: json['rental_fee'],
    condition: ConditionModel.values.byName(json['condition']),
    usage: json['usage'],
    purchaseDetails: PurchaseDetails.fromJson(json['purchase_details']),
    properties: List<Property>.from(json['properties'].map((x) => Property.fromJson(x))),
    materialType: MaterialTypeModel.fromJson(json['material_type']),
  );
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

  factory SerialNumber.fromJson(Map<String, dynamic> json) => SerialNumber(
    serialNumber: json['serial_number'],
    manufacturer: json['manufacturer'],
    productionDate: DateTime.parse(json['production_date']),
  );
}

enum ConditionModel {
  ok,
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
    purchaseDate: DateTime.parse(json['purchase_date']),
    invoiceNumber: json['invoice_number'],
    merchant: json['merchant'],
    productionDate: DateTime.parse(json['production_date']),
    purchasePrice: json['purchase_price'],
    suggestedRetailPrice: json['suggested_retail_price'],
  );
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

  factory Property.fromJson(Map<String, dynamic> json) => Property(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    value: json['value'],
    unit: json['unit'],
  );
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

  factory MaterialTypeModel.fromJson(Map<String, dynamic> json) => MaterialTypeModel(
    id: json['id'],
    name: json['name'],
    description: json['description'],
  );
}
