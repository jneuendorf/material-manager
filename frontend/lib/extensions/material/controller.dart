import 'package:get/get.dart';

import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/extensions/material/mock_data.dart';


class MaterialController extends GetxController {
  /// Fetches all material from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<MaterialModel>> getAllMaterial() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return mockMaterial + mockMaterial;
  }

  /// Fetches all equipment types from backend.
  /// /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<EquipmentType>> getAllEquipmentTypes() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      mockCarbineEquipmentType,
      mockHelmetEquipmentType,
      mockRopeEquipmentType,
    ];
  }
}