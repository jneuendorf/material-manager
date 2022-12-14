import 'package:frontend/extensions/material/model.dart';


final MaterialTypeModel mockRopeMaterialType = MaterialTypeModel(
  id: 1,
  name: 'Seil',
  description: 'Seil zum Klettern',
);

final MaterialTypeModel mockHelmetMaterialType = MaterialTypeModel(
  id: 2,
  name: 'Helm',
  description: 'Helm zum Klettern',
);

final MaterialTypeModel mockCarbineMaterialType = MaterialTypeModel(
  id: 3,
  name: 'Karabiner',
  description: 'Karabiner zum Klettern',
);


final Property mockLengthProperty = Property(
  id: 1,
  propertyType: PropertyType(
    id: 1,
    name: 'Länge',
    description: 'Länge des Seils',
    unit: 'm',
  ),
  value: '10',
);

final Property mockThicknessProperty = Property(
  id: 1,
  propertyType: PropertyType(
    id: 2,
    name: 'Dicke',
    description: 'Dicke des Seils',
    unit: 'cm',
  ),
  value: '3',
);

final Property mockSizeProperty = Property(
  id: 1,
  propertyType: PropertyType(
    id: 3,
    name: 'Größe',
    description: 'Größe des Helms',
    unit: 'cm',
  ),
  value: '55',
);


final PurchaseDetails mockPurchaseDetails = PurchaseDetails(
  id: 1,
  purchaseDate: DateTime(2021, 1, 1),
  invoiceNumber: '123456',
  merchant: 'Kletterladen',
  // productionDate: DateTime(2020, 1, 1),
  purchasePrice: 10,
  suggestedRetailPrice: 20,
);


final SerialNumber mockSerialNumber = SerialNumber(
  serialNumber: 'sn-0-0',
  manufacturer: 'Kletter-Stuff XY',
  productionDate: DateTime(2020, 1, 1),
);


final List<MaterialModel> mockMaterial = [
  MaterialModel(
    id: 1,
    imageUrls: ['https://picsum.photos/250?image=1'],
    serialNumbers: [
      mockSerialNumber,
    ],
    inventoryNumbers: [
      InventoryNumber(id: 1, inventoryNumber: '235vh2354-2'),
    ],
    maxOperatingYears: 1,
    maxDaysUsed: 100,
    installationDate: DateTime(2021, 1, 1),
    instructions: 'Use with care',
    nextInspectionDate: DateTime(2022, 2, 1),
    rentalFee: 5,
    condition: ConditionModel.ok,
    daysUsed: 4,
    purchaseDetails: mockPurchaseDetails,
    materialType: mockRopeMaterialType,
    properties: [
      mockLengthProperty,
      mockThicknessProperty,
    ],
  ),
  MaterialModel(
    id: 2,
    imageUrls: ['https://picsum.photos/250?image=9'],
    serialNumbers: [
      mockSerialNumber,
    ],
    inventoryNumbers: [
      InventoryNumber(id: 2, inventoryNumber: '235vh2354-3'),
    ],
    maxOperatingYears: 1.2,
    maxDaysUsed: 10,
    installationDate: DateTime(2021, 1, 1),
    instructions: 'Use with care',
    nextInspectionDate: DateTime(2022, 2, 1),
    rentalFee: 7,
    condition: ConditionModel.ok,
    daysUsed: 4,
    purchaseDetails: mockPurchaseDetails,
    materialType: mockHelmetMaterialType,
    properties: [
      mockSizeProperty,
    ],
  ),
  MaterialModel(
    id: 3,
    imageUrls: ['https://picsum.photos/250?image=9'],
    serialNumbers: [
      mockSerialNumber,
    ],
    inventoryNumbers: [
      InventoryNumber(id: 2, inventoryNumber: '235vh2354-3'),
    ],
    maxOperatingYears: 2,
    maxDaysUsed: 100,
    installationDate: DateTime(2019, 1, 1),
    instructions: 'Use with care',
    nextInspectionDate: DateTime(2022, 2, 1),
    rentalFee: 2,
    condition: ConditionModel.ok,
    daysUsed: 4,
    purchaseDetails: mockPurchaseDetails,
    materialType: mockCarbineMaterialType,
    properties: [
      mockThicknessProperty,
    ],
  ),
  MaterialModel(
    id: 4,
    imageUrls: ['https://picsum.photos/250?image=1'],
    serialNumbers: [
      mockSerialNumber,
    ],
    inventoryNumbers: [
      InventoryNumber(id: 4, inventoryNumber: 'q35vh2fc4-2'),
    ],
    maxOperatingYears: 0.5,
    maxDaysUsed: 100,
    installationDate: DateTime(2021, 1, 1),
    instructions: 'Use with care',
    nextInspectionDate: DateTime(2022, 6, 1),
    rentalFee: 5,
    condition: ConditionModel.broken,
    daysUsed: 8,
    purchaseDetails: mockPurchaseDetails,
    materialType: mockRopeMaterialType,
    properties: [
      mockLengthProperty,
      mockThicknessProperty,
    ],
  ),
];

