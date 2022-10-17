import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/common/models/material.dart';
import 'package:frontend/common/models/mockData/mock_data_material.dart';


const rentalRoute = '/rental';

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
  
  final RxList<MaterialModel> availibleMaterial = <MaterialModel>[].obs;
  final RxList<MaterialModel> availibleSets = <MaterialModel>[].obs;

  final RxString searchTerm = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });

    availibleMaterial.value = await getAllMaterial();
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

    return mockMaterial;
  }

  /// Calculates the total price of all material in the [shoppingCart].
  double get totalPrice => shoppingCart.fold(0.0, 
    (double previousValue, MaterialModel item) => previousValue + item.rentalFee);
}