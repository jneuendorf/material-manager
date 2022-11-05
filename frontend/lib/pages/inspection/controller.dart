import 'package:get/get.dart';

import 'package:frontend/extensions/inspection/model.dart';
import 'package:frontend/extensions/inspection/controller.dart';
import 'package:frontend/extensions/material/mock_data.dart';
import 'package:frontend/extensions/material/controller.dart';
import 'package:frontend/extensions/material/model.dart';


const inspectionRoute = '/inspection';

class InspectionPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InspectionPageController>(() => InspectionPageController());
  }
}

class InspectionPageController extends GetxController {
  final materialController = Get.find<MaterialController>();
  final inspectionController = Get.find<InspectionController>();

  final Rxn<MaterialModel> currentMaterial = Rxn<MaterialModel>();
  final Rxn<InspectionType> selectedInspectionType = Rxn<InspectionType>();

  final List<String> availableInspectionTypes = [
    InspectionType.psaInspection.name, 
    InspectionType.sightInspection.name,
  ];

  @override
  Future<void> onInit() async {
    super.onInit();

    currentMaterial.value = mockMaterial.first;
  }

}

