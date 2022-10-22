import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:frontend/extensions/user/controller.dart';
import 'package:frontend/extensions/user/model.dart';


const administrationRoute = '/administration';

class AdministrationPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdministrationPageController>(() => AdministrationPageController());
  }
}

class AdministrationPageController extends GetxController with GetSingleTickerProviderStateMixin {
  final userController = Get.find<UserController>();

  final RxInt tabBarIndex = 0.obs;
  late TabController tabbBarController;
  List<UserModel> availableUsers = [];
  List<Role> roles = [];
  final Rxn<Role> selectedFilter = Rxn<Role>();

  @override
  Future<void> onInit() async {
    super.onInit();

    tabbBarController = TabController(length: 2, vsync: this);
    tabbBarController.addListener(() {
      tabBarIndex.value = tabbBarController.index;
    });

    availableUsers = await userController.getAllUsers();

    roles = await userController.getAllRoles();
  }
  void onFilterSelected(String value) {

  }
}
