import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:frontend/extensions/rental/controller.dart';
import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/extensions/user/controller.dart';
import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/extensions/material/controller.dart';


const lenderRoute = '/lender';

class LenderPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LenderPageController>(() => LenderPageController());
  }
}

class LenderPageController extends GetxController with GetSingleTickerProviderStateMixin {
  final rentalController = Get.find<RentalController>();
  final userController =  Get.find<UserController>();
  final materialController =  Get.find<MaterialController>();

  final RxInt tabBarIndex = 0.obs;
  late TabController tabbBarController;

  final RxList<RentalModel> filteredRentals = <RentalModel>[].obs;
  final RxMap<RentalStatus, String> statusOptions = <RentalStatus, String>{}.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    tabbBarController = TabController(length: 2, vsync: this);
    tabbBarController.addListener(() {
      tabBarIndex.value = tabbBarController.index;
    });

    await rentalController.initCompleter.future;
    await userController.initCompleter.future;
    await materialController.initCompleter.future;

    filteredRentals.value = rentalController.rentals;

    for (RentalStatus item in rentalController.statuses) {
      statusOptions[item] = item.name;
    }
  }

  @override
  void onClose() {
    tabbBarController.dispose();
    super.onClose();
  }

  String getUserName(RentalModel item) {
    UserModel user = userController.users.firstWhere(
      (UserModel user) => user.id == item.id);
    
    return '${user.firstName} ${user.lastName}';
  }

  String getMembershipNum(RentalModel item) {

    String membershipNum = userController.users.firstWhere((UserModel user) =>
      user.id == item.id).membershipNumber.toString();
    return membershipNum;
  }

  String getRentalPeriod(RentalModel item) {
    String rentalPeriod = '${formatDate(item.startDate)} ${' - '} ${formatDate(item.endDate)}';
    return rentalPeriod;
  }

  String getUsagePeriod(RentalModel item) {
    String rentalPeriod = '${formatDate(item.usageStartDate)} ${' - '} ${formatDate(item.usageEndDate)}';
    return rentalPeriod;
  }

  String? getMaterialPicture(RentalModel item, int materialIndex) {
    String path = materialController.materials.firstWhere((MaterialModel material) =>
    material.id == item.materialIds[materialIndex]).imageUrls.first;
    return path;
  }

  String getItemName(RentalModel item, int materialIndex) {
    String itemName = materialController.materials.firstWhere((MaterialModel material) =>
    material.id == item.materialIds[materialIndex]).materialType.name;
    return itemName;
  }

  String getItemPrice(RentalModel item, int materialIndex) {
    String itemPrice = materialController.materials.firstWhere((MaterialModel material) =>
    material.id == item.materialIds[materialIndex]).rentalFee.toStringAsFixed(2);
    return itemPrice;
  }

  String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

}
