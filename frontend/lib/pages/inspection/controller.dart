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


  final RxList<String> availableInspectionTypes = <String>[].obs;
  final RxList<MaterialModel> availableMaterial = <MaterialModel>[].obs;
  final RxList<InspectionModel> availableInspections = <InspectionModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    availableMaterial.value = await materialController.getAllMaterialMocks();
    availableInspectionTypes.value = [InspectionType.psaInspection.name, InspectionType.sightInspection.name];
    currentMaterial.value = mockMaterial.first;

    availableInspections.value  = await inspectionController.getAllMockInspections();
  }
}

