import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:cross_file/cross_file.dart';

import 'package:frontend/api.dart';
import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/extensions/material/mock_data.dart';
import 'package:frontend/common/core/models.dart';
import 'package:frontend/common/util.dart';


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

    if (isTest()) {
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
    if (!isTest()) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    debugPrint('Called getAllMaterialMocks');

    return mockMaterial + mockMaterial;
  }

  Future<List<Property>> getAllMaterialPropertyMocks() async {
    if (!isTest()) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    debugPrint('Called getAllMaterialPropertyMocks');

    return [mockLengthProperty,mockThicknessProperty, mockSizeProperty];
  }

  /// Fetches all material types from backend.
  /// /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<MaterialTypeModel>> getAllMaterialTypeMocks() async {
    if (!isTest()) {
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

  /// Fetches all property types of the provided [materialTypeName] from backend.
  Future<List<PropertyType>?> getPropertyTypesByMaterialTypeName(String materialTypeName) async {
    try {
      final response = await apiService.mainClient.get('/property_types/$materialTypeName');

      if (response.statusCode != 200) debugPrint('Error getting property types');

      return response.data.map<PropertyType>(
        (dynamic item) => PropertyType.fromJson(item)
      ).toList();
    } on dio.DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Adds a new material to the backend.
  /// Returns the id of the newly created material
  /// or null if an error occurred.
  Future<int?> addMaterials({
    required List<XFile> imageFiles,
    required List<NonFinalMapEntry<String?, List<SerialNumber>>> bulkValues,
    required MaterialTypeModel materialType,
    required List<Property> properties,
    required double rentalFee,
    required double maxOperatingYears,
    required int maxDaysUsed,
    required DateTime nextInspectionDate,
    required String merchant,
    required dynamic instructions, // url as String or file as XFile
    required DateTime purchaseDate,
    required double purchasePrice,
    required double suggestedRetailPrice,
    required String invoiceNumber,
    required String manufacturer,
  }) async {
    try {
      var serialNumbers = bulkValues.map(
        (NonFinalMapEntry<String?, List<SerialNumber>> values) => values.value.map(
          (SerialNumber num) => {
            'serial_number':  num.serialNumber,
            'production_date': isoDateFormat.format(num.productionDate),
            'manufacturer': manufacturer,
          }
        ).toList()
      ).toList();
      List images = await Future.wait(imageFiles.map(
        (XFile f) async => {
          'base64': base64.encode(await f.readAsBytes()),
          'mime_type': f.mimeType,
          'filename': f.name,
        }
      ).toList());
      if (instructions is XFile) {
        instructions = {
          'base64': base64.encode(await instructions.readAsBytes()),
          'mime_type': instructions.mimeType,
          'filename': instructions.name,
        };
      }
      final response = await apiService.mainClient.post('/materials',
        data: {
          'material_type': {
            'id': materialType.id,
            'name': materialType.name,
            'description': materialType.description,
          },
          'serial_numbers': serialNumbers,
          'inventory_numbers': bulkValues.map((NonFinalMapEntry<String?, List<SerialNumber>> values) => {
            'inventory_number':  values.key,
          }).toList(),
          'purchase_details': {
            'purchase_date': isoDateFormat.format(purchaseDate),
            'invoice_number': invoiceNumber,
            'merchant': merchant,
            'purchase_price': purchasePrice,
            'suggested_retail_price': suggestedRetailPrice,
          },
          'images': images,
          'rental_fee': rentalFee,
          'max_operating_years': maxOperatingYears,
          'max_days_used': maxDaysUsed,
          'next_inspection_date': isoDateFormat.format(nextInspectionDate),
          'instructions': instructions,
          'properties': properties.map((Property p) => {
            'value': p.value,
            'property_type': {
              'name': p.propertyType.name,
              'unit': p.propertyType.unit,
            },
          }).toList(),
        },
      );

      return response.statusCode;
    } on dio.DioError catch(e) {
      debugPrint('Error while trying to add material:');
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Updates a material in the backend.
  /// If [imageFiles] is not null, the images will be updated 
  /// and [material]´s imageUrls will be ignored.
  /// Returns true if the material was updated successfully.
  Future<bool> updateMaterial(MaterialModel material, {List<XFile>? imageFiles}) async {
    try {
      List images = [];
      if (imageFiles != null) {
        images = await Future.wait(imageFiles.map(
          (XFile f) async => {
            'base64': base64.encode(await f.readAsBytes()),
            'mime_type': f.mimeType,
            'filename': f.name,
          }
        ).toList());
      }

      final response = await apiService.mainClient.put('/material/${material.id}',
        data: {
          if (imageFiles == null) 'image_urls': material.imageUrls 
          else 'images': images,
          'serial_numbers': material.serialNumbers.map((SerialNumber s) => {
            'serial_number': s.serialNumber,
            'manufacturer': s.manufacturer,
            'production_date': isoDateFormat.format(s.productionDate),
          }).toList(),
          'inventory_numbers': material.inventoryNumbers.map((InventoryNumber i) => {
            'id': i.id,
            'inventory_number': i.inventoryNumber,
          }).toList(),
          'max_operating_years': material.maxOperatingYears,
          'max_days_used': material.maxDaysUsed,
          if (material.installationDate != null) 'installation_date': isoDateFormat.format(material.installationDate!),
          'instructions': material.instructions,
          'next_inspection_date': isoDateFormat.format(material.nextInspectionDate),
          'rental_fee': material.rentalFee,
          'condition': material.condition.name,
          'usage': material.daysUsed,
          'purchase_details': {
            'id' : material.purchaseDetails.id,
            'purchase_date': isoDateFormat.format(material.purchaseDetails.purchaseDate),
            'invoice_number': material.purchaseDetails.invoiceNumber,
            'merchant': material.purchaseDetails.merchant,
            'purchase_price': material.purchaseDetails.purchasePrice,
            'suggested_retail_price': material.purchaseDetails.suggestedRetailPrice,
          },
          'properties': material.properties.map((Property p) => {
            'id': p.id,
            'value': p.value,
            'property_type': {
              'name': p.propertyType.name,
              'unit': p.propertyType.unit,
            },
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

  // /// Adds a new material type to the backend.
  // /// Returns the id of the newly created material type.
  // Future<int?> addMaterialType(MaterialTypeModel materialType) async {
  //   try {
  //     final response = await apiService.mainClient.post('/material_type',
  //       data: {
  //         'name': materialType.name,
  //         'description': materialType.description,
  //       },
  //     );

  //     if (response.statusCode != 201) debugPrint('Error adding material type');

  //     return response.data['id'];
  //   } on dio.DioError catch(e) {
  //     apiService.defaultCatch(e);
  //   }
  //   return null;
  // }

  // /// Adds a new property to the backend.
  // /// Returns the id of the newly created property.
  // Future<int?> addProperty(Property property) async {
  //   try {
  //     final response = await apiService.mainClient.post('/material_property',
  //       data: {
  //         'property_type': property.propertyType,
  //         'value': property.value,
  //       },
  //     );

  //     if (response.statusCode != 201) debugPrint('Error adding property');

  //     return response.data['id'];
  //   } on dio.DioError catch(e) {
  //     apiService.defaultCatch(e);
  //   }
  //   return null;
  // }

  // /// Updates a material type in the backend.
  // /// Returns true if the material type was updated successfully.
  // Future<bool> updateMaterialType(MaterialTypeModel materialType) async {
  //   try {
  //     final response = await apiService.mainClient.put('/material_type/${materialType.id}',
  //       data: {
  //         'name': materialType.name,
  //         'description': materialType.description,
  //       },
  //     );

  //     if (response.statusCode != 200) debugPrint('Error updating material type');

  //     return response.statusCode == 200;
  //   } on dio.DioError catch(e) {
  //     apiService.defaultCatch(e);
  //   }
  //   return false;
  // }

  // /// Updates a property in the backend.
  // /// Returns true if the property was updated successfully.
  // Future<bool> updateProperty(Property property) async {
  //   try {
  //     final response = await apiService.mainClient.put('/material_property/${property.id}',
  //       data: {
  //         'property_type': property.propertyType,
  //         'value': property.value,
  //       },
  //     );

  //     if (response.statusCode != 200) debugPrint('Error updating property');

  //     return response.statusCode == 200;
  //   } on dio.DioError catch(e) {
  //     apiService.defaultCatch(e);
  //   }
  //   return false;
  // }
}
