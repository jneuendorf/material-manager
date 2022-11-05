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
  name: 'Länge',
  description: 'Länge des Seils',
  value: '10',
  unit: 'm',
);

final Property mockThicknessProperty = Property(
  id: 2,
  name: 'Dicke',
  description: 'Dicke des Seils',
  value: '3',
  unit: 'cm',
);

final Property mockSizeProperty = Property(
  id: 3,
  name: 'Größe',
  description: 'Größe des Helms',
  value: '55',
  unit: 'cm',
);


final PurchaseDetails mockPurchaseDetails = PurchaseDetails(
  id: 1,
  purchaseDate: DateTime(2021, 1, 1),
  invoiceNumber: '123456',
  merchant: 'Kletterladen',
  productionDate: DateTime(2020, 1, 1),
  purchasePrice: 10,
  suggestedRetailPrice: 20,
);


final SerialNumber mockSerialNumber = SerialNumber(
  id: 1,
  manufacturer: 'Kletter-Stuff XY',
);


final List<MaterialModel> mockMaterial = [
  MaterialModel(
    id: 1,
    imagePath: 'https://picsum.photos/250?image=1',
    serialNumbers: [
      mockSerialNumber,
    ],
    inventoryNumber: '235vh2354-2',
    maxLifeExpectancy: '10 years',
    maxServiceDuration: '10 years',
    installationDate: DateTime(2021, 1, 1),
    instructions: 'Use with care',
    nextInspectionDate: DateTime(2022, 2, 1),
    rentalFee: 5,
    condition: ConditionModel.good,
    usage: 4,
    purchaseDetails: mockPurchaseDetails,
    materialType: mockRopeMaterialType,
    properties: [
      mockLengthProperty, 
      mockThicknessProperty,
    ],
  ),
  MaterialModel(
    id: 2,
    imagePath: 'https://picsum.photos/250?image=9',
    serialNumbers: [
      mockSerialNumber,
    ],
    inventoryNumber: '235vh2354-3',
    maxLifeExpectancy: '10 years',
    maxServiceDuration: '10 years',
    installationDate: DateTime(2021, 1, 1),
    instructions: 'Use with care',
    nextInspectionDate: DateTime(2022, 2, 1),
    rentalFee: 7,
    condition: ConditionModel.good,
    usage: 4,
    purchaseDetails: mockPurchaseDetails,
    materialType: mockHelmetMaterialType,
    properties: [
      mockSizeProperty,
    ],
  ),
  MaterialModel(
    id: 3,
    imagePath: 'https://picsum.photos/250?image=9',
    serialNumbers: [
      mockSerialNumber,
    ],
    inventoryNumber: 'cg135vh2354-3',
    maxLifeExpectancy: '20 years',
    maxServiceDuration: '10 years',
    installationDate: DateTime(2019, 1, 1),
    instructions: 'Use with care',
    nextInspectionDate: DateTime(2022, 2, 1),
    rentalFee: 2,
    condition: ConditionModel.good,
    usage: 4,
    purchaseDetails: mockPurchaseDetails,
    materialType: mockCarbineMaterialType,
    properties: [
      mockThicknessProperty,
    ],
  ),
  MaterialModel(
    id: 4,
    imagePath: 'https://picsum.photos/250?image=1',
    serialNumbers: [
      mockSerialNumber,
    ],
    inventoryNumber: 'q35vh2fc4-2',
    maxLifeExpectancy: '10 years',
    maxServiceDuration: '10 years',
    installationDate: DateTime(2021, 1, 1),
    instructions: 'Use with care',
    nextInspectionDate: DateTime(2022, 6, 1),
    rentalFee: 5,
    condition: ConditionModel.broken,
    usage: 8,
    purchaseDetails: mockPurchaseDetails,
    materialType: mockRopeMaterialType,
    properties: [
      mockLengthProperty, 
      mockThicknessProperty,
    ],
  ),
];

