import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/extensions/material/controller.dart';


const inventoryRoute = '/inventory';

class InventoryPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InventoryPageController>(() => InventoryPageController());
  }
}

class InventoryPageController extends GetxController {
    final materialController = Get.find<MaterialController>();

    final RxList<MaterialModel> filteredMaterial = <MaterialModel>[].obs;
    final RxMap<EquipmentType, String> typeFilterOptions = <EquipmentType, String>{}.obs;
    final RxBool selectAll = false.obs;

    final Rxn<EquipmentType> selectedTypeFilter = Rxn<EquipmentType>();
    final Rxn<ConditionModel> selectedConditionFilter = Rxn<ConditionModel>();
    final RxString searchTerm = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    
    await materialController.initCompleter.future;

    filteredMaterial.value = materialController.materials;

    for (EquipmentType item in materialController.types) {
      typeFilterOptions[item] = item.description;
    }
  }

   /// Filters the [availableMaterial] by the [searchTerm], 
   /// the [selectedTypeFilter] and the [selectedConditonFilter].
  void runFilter() {
    final String term = searchTerm.value.toLowerCase();
    filteredMaterial.value = materialController.materials.where((MaterialModel item) {
      /// Checks if the [selectedTypeFilter] equals [equipmentType] of the [item].
      bool equipmentTypeFilterCondition() {
        if (selectedTypeFilter.value == null) return true;
        
        return item.equipmentType == selectedTypeFilter.value;
      }

      /// Checks if the [term] is contained in [equipmentType] of the [item].
      bool equipmentTypeNameCondition() {
        if (term.isEmpty) return true;

        return item.equipmentType.description.toLowerCase().contains(term);
      }

      bool conditionFilterCondition() {
        if (selectedConditionFilter.value == null) return true;

        return item.condition == selectedConditionFilter.value;
      }

      return equipmentTypeFilterCondition() && 
        equipmentTypeNameCondition() && conditionFilterCondition();
    }).toList();
  }

  /// Handles the selection of a [value] out of [typeFilterOption].
  void onTypeFilterSelected(String value) {
    // set selected filter
    if (value != 'all'.tr) {
      selectedTypeFilter.value = typeFilterOptions.entries.firstWhere(
        (MapEntry<EquipmentType, String> entry) => entry.value == value
      ).key;
    } else {
      selectedTypeFilter.value = null;
    }

    runFilter();
  }

  /// Handles the selection of a [value] out of all conditons.
  void onConditionFilterSelected(String value) {
    // set selected filter
    if (value != 'all'.tr) {
      selectedConditionFilter.value = ConditionModel.values.firstWhere(
        (ConditionModel condition) => condition.toString().split('.').last.tr == value
      );
    } else {
      selectedConditionFilter.value = null;
    }

    runFilter();
  }

  String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }
}