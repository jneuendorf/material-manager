import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:frontend/extensions/inspection/mock_data.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/inspection/model.dart';


const inspectionRoute = '/inspection';

class InspectionPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InspectionPageController>(() => InspectionPageController());
  }
}

class InspectionPageController extends GetxController {
  final RxList<InspectionModel> inspections = <InspectionModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    inspections.value = await getAllInspectionMocks();
  }

  /// Fetches all inspections from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<InspectionModel>> getAllInspectionMocks()  async {
    if (!kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST')) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return mockInspections + mockInspections;
  }

}