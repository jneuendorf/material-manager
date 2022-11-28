import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:cross_file/cross_file.dart';

import 'package:frontend/api.dart';
import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/extensions/material/mock_data.dart';


class MaterialController extends GetxController {
  static final apiService = Get.find<ApiService>();

  final Completer initCompleter = Completer();

  final RxList<MaterialModel> materials = <MaterialModel>[].obs;
  final RxList<MaterialTypeModel> types = <MaterialTypeModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    debugPrint('MaterialController init');

    initCompleter.future;

    if (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')) {
      initCompleter.complete();
      return;
    }

    await Future.wait([
        _initMaterials(),
        _initTypes(),
      ]);

    initCompleter.complete();
  }

  Future<void> _initMaterials() async {
    materials.value = (await getAllMaterial()) ?? [];
  }

  Future<void> _initTypes() async {
    types.value = (await getAllMaterialTypes()) ?? [];
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

  /// Fetches all material types from backend.
  /// /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<MaterialTypeModel>> getAllMaterialTypeMocks() async {
    if (!kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST')) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return [
      mockCarbineMaterialType,
      mockHelmetMaterialType,
      mockRopeMaterialType,
    ];
  }

  /// Fetches all material from backend.
  Future<List<MaterialModel>?> getAllMaterial() async {
    try {
      final response = await apiService.mainClient.get('/materials');

      if (response.statusCode != 200) debugPrint('Error getting material');

      return response.data.map<MaterialModel>(
        (dynamic item) => MaterialModel.fromJson(item)
      ).toList();
    } on dio.DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Fetches all material types from backend.
  Future<List<MaterialTypeModel>?> getAllMaterialTypes() async {
    try {
      final response = await apiService.mainClient.get('/material_types');

      if (response.statusCode != 200) debugPrint('Error getting material types');

      return response.data.map<MaterialTypeModel>(
        (dynamic item) => MaterialTypeModel.fromJson(item)
      ).toList();
    } on dio.DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Adds a new material to the backend.
  /// Returns the id of the newly created material
  /// or null if an error occurred.
  Future<int?> addMaterial(MaterialModel material, XFile image) async {
    try {
      final response = await apiService.mainClient.post('/material',
        data: dio.FormData.fromMap({
          'file': await dio.MultipartFile.fromFile(image.path),
          'serial_numbers': material.serialNumbers.map((SerialNumber s) => {
            'serial_number': s.serialNumber,
            'manufacturer': s.manufacturer,
            'production_date': s.productionDate,
          }).toList(),
          'inventory_number': material.inventoryNumbers,
          'max_operating_date': material.maxOperatingDate,
          'max_days_used': material.maxDaysUsed,
          'installation_date': material.installationDate,
          'instructions': material.instructions,
          'next_inspection_date': material.nextInspectionDate,
          'rental_fee': material.rentalFee,
          'condition': material.condition.name,
          'usage': material.daysUsed,
          'purchase_details': {
            'id' : material.purchaseDetails.id,
            'purchase_date': material.purchaseDetails.purchaseDate,
            'invoice_number': material.purchaseDetails.invoiceNumber,
            'merchant': material.purchaseDetails.merchant,
            // 'production_date': material.purchaseDetails.productionDate,
            'purchanse_price': material.purchaseDetails.purchasePrice,
            'suggested_retail_price': material.purchaseDetails.suggestedRetailPrice,
          },
          'properties': material.properties.map((Property p) => {
            'id': p.id,
            'property_type': p.propertyType,
            'value': p.value,
          }).toList(),
          'material_type': {
            'id': material.materialType.id,
            'name': material.materialType.name,
            'description': material.materialType.description,
          },
        }),
      );

      if (response.statusCode != 201) debugPrint('Error adding material');

      return response.data['id'];
    } on dio.DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Adds a new material type to the backend.
  /// Returns the id of the newly created material type.
  Future<int?> addMaterialType(MaterialTypeModel materialType) async {
    try {
      final response = await apiService.mainClient.post('/material_type',
        data: {
          'name': materialType.name,
          'description': materialType.description,
        },
      );

      if (response.statusCode != 201) debugPrint('Error adding material type');

      return response.data['id'];
    } on dio.DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Adds a new property to the backend.
  /// Returns the id of the newly created property.
  Future<int?> addProperty(Property property) async {
    try {
      final response = await apiService.mainClient.post('/material_property',
        data: {
          'property_type': property.propertyType,
          'value': property.value,
        },
      );

      if (response.statusCode != 201) debugPrint('Error adding property');

      return response.data['id'];
    } on dio.DioError catch(e) {
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
          'image_path': material.imageUrls,
          'serial_numbers': material.serialNumbers.map((SerialNumber s) => {
            'serial_number': s.serialNumber,
            'manufacturer': s.manufacturer,
            'production_date': s.productionDate,
          }).toList(),
          'inventory_number': material.inventoryNumbers,
          'max_operating_date': material.maxOperatingDate,
          'max_days_used': material.maxDaysUsed,
          'installation_date': material.installationDate,
          'instructions': material.instructions,
          'next_inspection_date': material.nextInspectionDate,
          'rental_fee': material.rentalFee,
          'condition': material.condition.name,
          'usage': material.daysUsed,
          'purchase_details': {
            'id' : material.purchaseDetails.id,
            'purchase_date': material.purchaseDetails.purchaseDate,
            'invoice_number': material.purchaseDetails.invoiceNumber,
            'merchant': material.purchaseDetails.merchant,
            // 'production_date': material.purchaseDetails.productionDate,
            'purchanse_price': material.purchaseDetails.purchasePrice,
            'suggested_retail_price': material.purchaseDetails.suggestedRetailPrice,
          },
          'properties': material.properties.map((Property p) => {
            'id': p.id,
            'property_type': p.propertyType,
            'value': p.value,
          }).toList(),
          'material_type': {
            'id': material.materialType.id,
            'name': material.materialType.name,
            'description': material.materialType.description,
          },
        },
      );

      if (response.statusCode != 200) debugPrint('Error updating material');

      return response.statusCode == 200;
    } on dio.DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return false;
  }

  /// Updates a material type in the backend.
  /// Returns true if the material type was updated successfully.
  Future<bool> updateMaterialType(MaterialTypeModel materialType) async {
    try {
      final response = await apiService.mainClient.put('/material_type/${materialType.id}',
        data: {
          'name': materialType.name,
          'description': materialType.description,
        },
      );

      if (response.statusCode != 200) debugPrint('Error updating material type');

      return response.statusCode == 200;
    } on dio.DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return false;
  }

  /// Updates a property in the backend.
  /// Returns true if the property was updated successfully.
  Future<bool> updateProperty(Property property) async {
    try {
      final response = await apiService.mainClient.put('/material_property/${property.id}',
        data: {
          'property_type': property.propertyType,
          'value': property.value,
        },
      );

      if (response.statusCode != 200) debugPrint('Error updating property');

      return response.statusCode == 200;
    } on dio.DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return false;
  }
}
