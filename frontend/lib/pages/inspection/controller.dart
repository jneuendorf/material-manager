import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/extensions/inspection/model.dart';
import 'package:frontend/extensions/inspection/controller.dart';
import 'package:frontend/extensions/material/controller.dart';
import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/extensions/user/controller.dart';
import 'package:frontend/extensions/user/model.dart';


const inspectionRoute = '/inspection';
const inspectionDetailRoute = '/inspection/inspectionDetail';

class InspectionPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InspectionPageController>(() => InspectionPageController());
  }
}

class InspectionPageController extends GetxController {
  final apiService = Get.find<ApiService>();
  final materialController = Get.find<MaterialController>();
  final inspectionController = Get.find<InspectionController>();
  final userController = Get.find<UserController>();

  final RxList<InspectionModel> filteredInspection = <InspectionModel>[].obs;
  final RxList<MaterialModel> filteredMaterial = <MaterialModel>[].obs;

  final RxMap<InspectionType, String> typeFilterOptions = <InspectionType, String>{}.obs;

  final Rxn<MaterialModel> selectedMaterial = Rxn<MaterialModel>();

  final Rxn<InspectionType> selectedInspectionType = Rxn<InspectionType>();
  final RxString searchTerm = ''.obs;
  final RxBool selectAll = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    for (InspectionType item in InspectionType.values) {
      typeFilterOptions[item] = item.name;
    }

    await Future.wait([
      inspectionController.initCompleter.future,
      materialController.initCompleter.future,
      userController.initCompleter.future,
    ]);

    filteredMaterial.value = materialController.materials.where(
      (MaterialModel item) => item.nextInspectionDate.difference(DateTime.now()) <= const Duration(days: 7) ||
        item.condition == ConditionModel.BROKEN
    ).toList();
  }

  /// Filters the [inspections by the [searchTerm] and
  /// the [selectedTypeFilter].
  void runFilter() {
    final String term = searchTerm.value.toLowerCase();
    filteredMaterial.value = materialController.materials.where(
      (MaterialModel item) {
        if (term.isEmpty) return true;

        return item.materialType.name.toLowerCase().contains(term);
      },
    ).toList();

  }

  /// Handles the selection of a [value] out of [typeFilterOption].
  void onTypeFilterSelected(String value) {}

  MaterialModel getMaterialById(int id) {
    return materialController.materials.firstWhere((MaterialModel element) => element.id == id);
  }

  /// Handles the selection of the provided [material].
  void onMaterialSelected(MaterialModel material) {
    selectedMaterial.value = material;

    Get.toNamed(inspectionDetailRoute);
  }

  String getInspectorName(int inspectorId) {
    return '${userController.users.firstWhere((UserModel user) => user.id == inspectorId).firstName} ${userController.users.firstWhere((UserModel user) => user.id == inspectorId).lastName}';
  }
}

