import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:frontend/extensions/rental/controller.dart';
import 'package:frontend/extensions/rental/model.dart';


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
  List<RentalModel> availableRentals = [];
  final Rxn<RentalStatus> rentalStatus = Rxn<RentalStatus>();

  @override
  Future<void> onInit() async {
    super.onInit();

    tabbBarController = TabController(length: 2, vsync: this);
    tabbBarController.addListener(() {
      tabBarIndex.value = tabbBarController.index;
    });

    availableRentals = await rentalController.getAllRentals();
  }

  void onFilterSelected(String value) {

  }
}
