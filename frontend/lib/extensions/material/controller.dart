import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:dio/dio.dart';

import 'package:frontend/api.dart';
import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/extensions/material/mock_data.dart';


class MaterialController extends GetxController {
  static final apiService = Get.find<ApiService>();

  final Completer initCompleter = Completer();

  final RxList<MaterialModel> materials = <MaterialModel>[].obs;
  final RxList<EquipmentType> types = <EquipmentType>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    debugPrint('MaterialController init');

    initCompleter.future;

    materials.value = await getAllMaterialMocks();
    types.value = await getAllEquipmentTypeMocks();

    initCompleter.complete();
  }

  /// Fetches all material from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<MaterialModel>> getAllMaterialMocks() async {
    if (!kIsWeb &&  !Platform.environment.containsKey('FLUTTER_TEST')) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    debugPrint('Called getAllMaterialMocks');

    return mockMaterial + mockMaterial;
  }

  /// Fetches all equipment types from backend.
  /// /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<EquipmentType>> getAllEquipmentTypeMocks() async {
    if (!kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST')) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    
    return [
      mockCarbineEquipmentType,
      mockHelmetEquipmentType,
      mockRopeEquipmentType,
    ];
  }

  /// Fetches all material from backend.
  Future<List<MaterialModel>?> getAllMaterial() async {
    try {
      final response = await apiService.mainClient.get('/material');

      if (response.statusCode != 200) debugPrint('Error getting material');

      return response.data['material'].map(
        (dynamic item) => MaterialModel.fromJson(item)
      ).toList();
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Fetches all equipment types from backend.
  Future<List<EquipmentType>?> getAllEquipmentTypes() async {
    try {
      final response = await apiService.mainClient.get('/material/equipment_type');

      if (response.statusCode != 200) debugPrint('Error getting equipment types');

      return response.data['equipmentTypes'].map(
        (dynamic item) => EquipmentType.fromJson(item)
      ).toList();
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Adds a new material to the backend.
  /// Returns the id of the newly created material 
  /// or null if an error occured.
  Future<int?> addMaterial(MaterialModel material) async {
    try {
      final response = await apiService.mainClient.post('/material', 
        data: {
          'serial_numbers': material.serialNumbers.map((SerialNumber s) => {
            'id': s.id,
            'manufacturer': s.manufacturer,
          }).toList(),
          'inventory_number': material.inventoryNumber,
          'max_life_expectancy': material.maxLifeExpectancy,
          'max_service_duration': material.maxServiceDuration,
          'installation_date': material.installationDate,
          'instructions': material.instructions,
          'next_inspection_date': material.nextInspectionDate,
          'rental_fee': material.rentalFee,
          'condition': material.condition.name, 
          'usage': material.usage,
          'purchase_details': {
            'id' : material.purchaseDetails.id,
            'purchase_date': material.purchaseDetails.purchaseDate,
            'invoice_number': material.purchaseDetails.invoiceNumber,
            'merchant': material.purchaseDetails.merchant,
            'production_date': material.purchaseDetails.productionDate,
            'purchanse_price': material.purchaseDetails.purchasePrice,
            'suggested_retail_price': material.purchaseDetails.suggestedRetailPrice,
          },
          'properties': material.properties.map((Property p) => {
            'id': p.id,
            'name': p.name,
            'description': p.description,
            'value': p.value,
            'unit': p.unit,
          }).toList(),
          'equipment_type': {
            'id': material.equipmentType.id,
            'description': material.equipmentType.description,
          },
        },
      );

      if (response.statusCode != 201) debugPrint('Error adding material');

      return response.data['id'];
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Adds a new equipment type to the backend.
  /// Returns the id of the newly created equipment type.
  Future<int?> addEquipmentType(EquipmentType equipmentType) async {
    try {
      final response = await apiService.mainClient.post('/material/equipment_type', 
        data: {
          'description': equipmentType.description,
        },
      );

      if (response.statusCode != 201) debugPrint('Error adding equipment type');

      return response.data['id'];
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Adds a new property to the backend.
  /// Returns the id of the newly created property.
  Future<int?> addProperty(Property property) async {
    try {
      final response = await apiService.mainClient.post('/material/property', 
        data: {
          'name': property.name,
          'description': property.description,
          'value': property.value,
          'unit': property.unit,
        },
      );

      if (response.statusCode != 201) debugPrint('Error adding property');

      return response.data['id'];
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Updates a material in the backend.
  /// Returns true if the material was updated successfully.
  Future<bool> updateMaterial(MaterialModel material) async {
    try {
      final response = await apiService.mainClient.put('/material/${material.id}', 
        data: {
          'image_path': material.imagePath,
          'serial_numbers': material.serialNumbers.map((SerialNumber s) => {
            'id': s.id,
            'manufacturer': s.manufacturer,
          }).toList(),
          'inventory_number': material.inventoryNumber,
          'max_life_expectancy': material.maxLifeExpectancy,
          'max_service_duration': material.maxServiceDuration,
          'installation_date': material.installationDate,
          'instructions': material.instructions,
          'next_inspection_date': material.nextInspectionDate,
          'rental_fee': material.rentalFee,
          'condition': material.condition.name, 
          'usage': material.usage,
          'purchase_details': {
            'id' : material.purchaseDetails.id,
            'purchase_date': material.purchaseDetails.purchaseDate,
            'invoice_number': material.purchaseDetails.invoiceNumber,
            'merchant': material.purchaseDetails.merchant,
            'production_date': material.purchaseDetails.productionDate,
            'purchanse_price': material.purchaseDetails.purchasePrice,
            'suggested_retail_price': material.purchaseDetails.suggestedRetailPrice,
          },
          'properties': material.properties.map((Property p) => {
            'id': p.id,
            'name': p.name,
            'description': p.description,
            'value': p.value,
            'unit': p.unit,
          }).toList(),
          'equipment_type': {
            'id': material.equipmentType.id,
            'description': material.equipmentType.description,
          },
        },
      );

      if (response.statusCode != 200) debugPrint('Error updating material');

      return response.statusCode == 200;
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return false;
  }

  /// Updates a equipment type in the backend.
  /// Returns true if the equipment type was updated successfully.
  Future<bool> updateEquipmentType(EquipmentType equipmentType) async {
    try {
      final response = await apiService.mainClient.put('/material/equipment_type/${equipmentType.id}', 
        data: {
          'description': equipmentType.description,
        },
      );

      if (response.statusCode != 200) debugPrint('Error updating equipment type');

      return response.statusCode == 200;
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return false;
  }

  /// Updates a property in the backend.
  /// Returns true if the property was updated successfully.
  Future<bool> updateProperty(Property property) async {
    try {
      final response = await apiService.mainClient.put('/material/property/${property.id}', 
        data: {
          'name': property.name,
          'description': property.description,
          'value': property.value,
          'unit': property.unit,
        },
      );

      if (response.statusCode != 200) debugPrint('Error updating property');

      return response.statusCode == 200;
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return false;
  }
}