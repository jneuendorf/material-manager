import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/extensions/material/controller.dart';
import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/extensions/rental/controller.dart';
import 'package:frontend/common/util.dart';


const rentalRoute = '/rental';
const rentalShoppingCartRoute = '/rental/shoppingCart';
const rentalCompletedRoute = '/rental/completed';

class RentalPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RentalPageController>(() => RentalPageController());
  }
}

class RentalPageController extends GetxController with GetSingleTickerProviderStateMixin {
  final apiService = Get.find<ApiService>();
  final materialController = Get.find<MaterialController>();
  final rentalController = Get.find<RentalController>();

  final RxInt tabIndex = 0.obs;
  late TabController tabController;

  final Rxn<RentalPeriod> rentalPeriod = Rxn<RentalPeriod>();
  final RxList<MaterialModel> shoppingCart = <MaterialModel>[].obs;
  final RxList<MaterialModel> filteredMaterial = <MaterialModel>[].obs;
  final RxList<MaterialModel> filteredSets = <MaterialModel>[].obs;
  final RxMap<MaterialTypeModel, String> filterOptions = <MaterialTypeModel, String>{}.obs;

  final Rxn<MaterialTypeModel> selectedFilter = Rxn<MaterialTypeModel>();
  final RxString searchTerm = ''.obs;

  final Rx<TextEditingController> rentalStartController = TextEditingController().obs;
  final Rx<TextEditingController> rentalEndController = TextEditingController().obs;
  final Rx<TextEditingController> usageStartController = TextEditingController().obs;
  final Rx<TextEditingController> usageEndController = TextEditingController().obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    debugPrint('RentalPageController init!');

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });

    await materialController.initCompleter.future;

    filteredMaterial.value = materialController.materials;

    for (MaterialTypeModel item in materialController.types) {
      filterOptions[item] = item.name;
    }
  }

  @override
  void onClose() {
    tabController.dispose();

    debugPrint('RentalPageController disposed!');

    super.onClose();
  }


  /// Calculates the total price of all material in the [shoppingCart].
  double get totalPrice => shoppingCart.fold(0.0,
    (double previousValue, MaterialModel item) => previousValue + item.rentalFee);

  /// Filters the [availableMaterial] by the [searchTerm] and the [selectedFilter].
  void runFilter() {
    final String term = searchTerm.value.toLowerCase();
    filteredMaterial.value = materialController.materials.where((MaterialModel item) {
      /// Checks if the [selectedFilter] equals [materialType] of the [item].
      bool materialTypeFilterCondition() {
        if (selectedFilter.value == null) return true;

        return item.materialType.id == selectedFilter.value!.id;
      }

      /// Checks if the [term] is contained in [materialType] of the [item].
      bool materialTypeNameCondition() {
        if (term.isEmpty) return true;

        return item.materialType.name.toLowerCase().contains(term);
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

      return materialTypeFilterCondition() &&
        (propertyNameCondition() || materialTypeNameCondition());
    }).toList();
  }


  /// Handles the selection of a [value] out of [filterOption].
  void onFilterSelected(String value) {
    // set selected filter
    if (value != 'all'.tr) {
      selectedFilter.value = filterOptions.entries.firstWhere(
        (MapEntry<MaterialTypeModel, String> entry) => entry.value == value
      ).key;
    } else {
      selectedFilter.value = null;
    }

    runFilter();
  }

  /// Calls the DatePicker and returns the formatted date.
  Future<String?> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => child != null ? Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(
            onPrimary: Colors.white,
            primary: Get.theme.colorScheme.secondary
          )
        ),
        child: child
      ) : const SizedBox()
    );
    if (pickedDate == null) return null;

    return dateFormat.format(pickedDate);
  }

  String? validateDateTime(String? value) {
    if(value!.isEmpty) {
      return 'date_is_mandatory'.tr;
    }
    return null;
  }

  String? validateUsageStartDate(String? value) {
    if(value == null || value.isEmpty) {
      return 'date_is_mandatory'.tr;
    }

    DateTime usageStart = dateFormat.parse(value);
    DateTime rentalStart = dateFormat.parse(rentalStartController.value.text);

    if (usageStart.isBefore(rentalStart)) {
      return 'usage_start_must_be_after_rental_start'.tr;
    }
    return null;
  }

  String? validateUsageEndDate(String? value) {
    if(value == null || value.isEmpty) {
      return 'date_is_mandatory'.tr;
    }

    DateTime usageEnd = dateFormat.parse(value);
    DateTime rentalEnd = dateFormat.parse(rentalEndController.value.text);

    if (rentalEnd.isBefore(usageEnd)) {
      return 'usage_end_must_be_before_rental_end'.tr;
    }
    return null;
  }

  /// Handle checkout button press.
  Future<void> onCheckoutTap() async {
    if (rentalPeriod.value == null || !rentalPeriod.value!.valid) {
      Get.snackbar('usage_period'.tr, 'usage_period_not_valid'.tr);
      return;
    }

    RentalModel rental = RentalModel(
      customerId: apiService.tokenInfo!['sub'],
      materialIds: shoppingCart.map((MaterialModel item) => item.id!).toList(),
      cost: totalPrice,
      createdAt: DateTime.now(),
      startDate: dateFormat.parse(rentalStartController.value.text),
      endDate: dateFormat.parse(rentalEndController.value.text),
      usageStartDate: dateFormat.parse(usageStartController.value.text),
      usageEndDate: dateFormat.parse(usageEndController.value.text),
    );

    final int? id = await rentalController.addRental(rental);
    if (id != null) {
      Get.toNamed(rentalCompletedRoute);
    }
  }

  String cleanPropertyValue(String value) {
    double? val = double.tryParse(value);

    // if not a double, return as is
    if (val == null) return value;

    return val.toStringAsFixed(2);
  }

  String getPropertyString(MaterialModel item) {
    if (item.properties.isEmpty) return '';

    String value = cleanPropertyValue(item.properties.first.value);

    return '$value ${item.properties.first.propertyType.unit}';
  }

}

class RentalPeriod {
  final DateTime startDate;
  final DateTime endDate;
  final bool valid;

  RentalPeriod({
    required this.startDate,
    required this.endDate,
    required this.valid,
  });

}
