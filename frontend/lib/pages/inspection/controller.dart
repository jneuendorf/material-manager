import 'package:get/get.dart';

import 'package:frontend/extensions/inspection/model.dart';
import 'package:frontend/extensions/inspection/controller.dart';
import 'package:frontend/extensions/material/mock_data.dart';
import 'package:frontend/extensions/material/controller.dart';
import 'package:frontend/extensions/material/model.dart';


const inspectionRoute = '/inspection';
const inspectiontDetailRoute = '/inspection/inspectionDetail';

class InspectionPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InspectionPageController>(() => InspectionPageController());
  }
}

class InspectionPageController extends GetxController {
  final materialController = Get.find<MaterialController>();
  final inspectionController = Get.find<InspectionController>();

  final RxList<InspectionModel> filteredInspection = <InspectionModel>[].obs;

  final RxMap<InspectionType, String> typeFilterOptions = <InspectionType, String>{}.obs;

  final Rxn<MaterialModel> currentMaterial = Rxn<MaterialModel>();
  final Rxn<InspectionModel> selectedInspection = Rxn<InspectionModel>();
  final Rxn<InspectionType> selectedInspectionType = Rxn<InspectionType>();
  final RxString searchTerm = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    currentMaterial.value = mockMaterial.first;

    for (InspectionType item in InspectionType.values) {
      typeFilterOptions[item] = item.name;
    }

    await inspectionController.initCompleter.future;

    filteredInspection.value = inspectionController.inspections;
  }

  /// Filters the [inspections by the [searchTerm] and
   /// the [selectedTypeFilter].
  void runFilter() {
    final String term = searchTerm.value.toLowerCase();
  }

  /// Handles the selection of a [value] out of [typeFilterOption].
  void onTypeFilterSelected(String value) {}

  MaterialModel getMaterialById(int id) {
    return materialController.materials.firstWhere((MaterialModel element) => element.id == id);
  }

  /// Handles the selection of the provided [inspection].
  void onInspectionSelected(InspectionModel inspection) {
    selectedInspection.value = inspection;

    Get.toNamed(inspectiontDetailRoute);
  }

}

