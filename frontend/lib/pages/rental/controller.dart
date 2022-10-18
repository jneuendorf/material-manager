import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/common/models/material.dart';
import 'package:frontend/common/models/mockData/mock_data_material.dart';


const rentalRoute = '/rental';
const rentalShoppingCartRoute = '/rental/shoppingCart';

class RentalBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RentalController>(() => RentalController());
  }
}

class RentalController extends GetxController with GetSingleTickerProviderStateMixin {
  final RxInt tabIndex = 0.obs;
  late TabController tabController;

  final RxList<MaterialModel> shoppingCart = <MaterialModel>[].obs;
  final RxList<MaterialModel> filteredMaterial = <MaterialModel>[].obs;
  final RxList<MaterialModel> filteredSets = <MaterialModel>[].obs;
  final RxMap<EquipmentType, String> filterOptions = <EquipmentType, String>{}.obs;

  final Rxn<EquipmentType> selectedFilter = Rxn<EquipmentType>();
  final RxString searchTerm = ''.obs;

  List<MaterialModel> availibleMaterial = [];
  List<MaterialModel> availibleSets = [];

  @override
  Future<void> onInit() async {
    super.onInit();

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });

    availibleMaterial = await getAllMaterial();
    filteredMaterial.value = availibleMaterial;

    // get all types of material
    for (MaterialModel item in availibleMaterial) {
      for (EquipmentType type in item.equipmentTypes) {
        if (!filterOptions.keys.contains(type)) {
          filterOptions[type] = type.description;
        }
      }
    }
  }

  @override
  void onClose() {
    tabController.dispose();

    super.onClose();
  }

  /// Fetches all material from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<MaterialModel>> getAllMaterial() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return mockMaterial + mockMaterial;
  }

  /// Calculates the total price of all material in the [shoppingCart].
  double get totalPrice => shoppingCart.fold(0.0, 
    (double previousValue, MaterialModel item) => previousValue + item.rentalFee);

  /// Filters the [availibleMaterial] by the [searchTerm] and the [selectedFilter].
  void runFilter() {
    final String term = searchTerm.value.toLowerCase();
    filteredMaterial.value = availibleMaterial.where((MaterialModel item) {
      /// Checks if the [selectedFilter] is contained in [equipmentTypes] of the [item].
      bool equipmentTypeFilterCondition() {
        if (selectedFilter.value == null) {
          return true;
        } else {
          return item.equipmentTypes.contains(selectedFilter.value);
        }
      }

      /// Checks if the [term] is contained in [equipmentTypes] of the [item].
      bool equipmentTypeNameCondition() {
        if (term.isEmpty) return true;

        for (EquipmentType type in item.equipmentTypes) {
          if (type.description.toLowerCase().contains(term)) {
            return true; 
          }
        }
        return false;
      }

      /// Checks if the [term] is contained in [properties] of the [item].
      bool propertyNameCondition() {
        if (term.isEmpty) return true;

        for (Property property in item.properties) {
          if (property.value.toLowerCase().contains(term)) {
            return true; 
          }
        }
        return false;
      }

      return equipmentTypeFilterCondition() && 
        (propertyNameCondition() || equipmentTypeNameCondition());
    }).toList();
  }


  /// Handles the selection of a [value] out of [filterOption].
  void onFilterSelected(String value) {
    // set selected filter
    if (value != 'all'.tr) {
      selectedFilter.value = filterOptions.entries.firstWhere(
        (MapEntry<EquipmentType, String> entry) => entry.value == value
      ).key;
    } else {
      selectedFilter.value = null;
    }

    runFilter();
  }

}