import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/extensions/material/mock_data.dart';


class MaterialController extends GetxController {
  /// Fetches all material from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<MaterialModel>> getAllMaterial() async {
    if (!kIsWeb &&  !Platform.environment.containsKey('FLUTTER_TEST')) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return mockMaterial + mockMaterial;
  }

  /// Fetches all equipment types from backend.
  /// /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<EquipmentType>> getAllEquipmentTypes() async {
    if (!kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST')) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    
    return [
      mockCarbineEquipmentType,
      mockHelmetEquipmentType,
      mockRopeEquipmentType,
    ];
  }
}