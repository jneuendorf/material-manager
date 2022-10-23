import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:frontend/extensions/rental/controller.dart';
import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/common/components/collapsable_expansion_tile.dart';


const lenderRoute = '/lender';

class LenderPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LenderPageController>(() => LenderPageController());
  }
}

class LenderPageController extends GetxController with GetSingleTickerProviderStateMixin {
  final rentalController = Get.find<RentalController>();

  final RxInt tabBarIndex = 0.obs;
  late TabController tabbBarController;

  final RxList<RentalModel> filteredRentals = <RentalModel>[].obs;
  final RxList<GlobalKey<CollapsableExpansionTileState>> keys = <GlobalKey<CollapsableExpansionTileState>>[].obs;

  List<RentalModel> availableRentals = [];
  List<RentalStatus> availableStatuses = [];

  @override
  Future<void> onInit() async {
    super.onInit();

    tabbBarController = TabController(length: 2, vsync: this);
    tabbBarController.addListener(() {
      tabBarIndex.value = tabbBarController.index;
    });

    availableRentals = await rentalController.getAllRentals();
    filteredRentals.value = availableRentals;

    keys.value = List.generate(
      filteredRentals.length, (index) => GlobalKey<CollapsableExpansionTileState>(),
    );

    availableStatuses = await rentalController.getAllStatuses();
  }

  @override
  void onClose() {
    tabbBarController.dispose();
    super.onClose();
  }

  void onFilterSelected(String value) {

  }

  String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }
}
