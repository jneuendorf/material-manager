import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/extensions/material/controller.dart';


const rentalRoute = '/rental';
const rentalShoppingCartRoute = '/rental/shoppingCart';

class RentalPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RentalPageController>(() => RentalPageController());
  }
}

class RentalPageController extends GetxController with GetSingleTickerProviderStateMixin {
  final materialController = Get.find<MaterialController>();

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
  List<EquipmentType> availibleEquipmentTypes = [];

  // following variables are used by the shopping cart page
  final GlobalKey<FormState> shoppingCartFormKey = GlobalKey<FormState>();

  final TextEditingController rentalStartController = TextEditingController();
  final TextEditingController rentalEndController = TextEditingController();
  final TextEditingController usageStartController = TextEditingController();
  final TextEditingController usageEndController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });

    availibleMaterial = await materialController.getAllMaterial();
    filteredMaterial.value = availibleMaterial;

    availibleEquipmentTypes = await materialController.getAllEquipmentTypes();

    for (EquipmentType item in availibleEquipmentTypes) {
      filterOptions[item] = item.description;
    }
  }

  @override
  void onClose() {
    tabController.dispose();

    super.onClose();
  }

  /// Calculates the total price of all material in the [shoppingCart].
  double get totalPrice => shoppingCart.fold(0.0, 
    (double previousValue, MaterialModel item) => previousValue + item.rentalFee);

  /// Filters the [availableMaterial] by the [searchTerm] and the [selectedFilter].
  void runFilter() {
    final String term = searchTerm.value.toLowerCase();
    filteredMaterial.value = availibleMaterial.where((MaterialModel item) {
      /// Checks if the [selectedFilter] equals [equipmentType] of the [item].
      bool equipmentTypeFilterCondition() {
        if (selectedFilter.value == null) return true;
          return item.equipmentType == selectedFilter.value;
      }

      /// Checks if the [term] is contained in [equipmentType] of the [item].
      bool equipmentTypeNameCondition() {
        if (term.isEmpty) return true;

        return item.equipmentType.description.toLowerCase().contains(term);
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

  /// Calls the DatePicker and returns the formated date.
  Future<String?> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate == null) return null;

    return DateFormat('dd.MM.yyyy').format(pickedDate);
  }

  String? validateDateTime(String? value) {
    if(value!.isEmpty) {
      return 'date_is_mandatory'.tr;
    }
    return null;
  }

}