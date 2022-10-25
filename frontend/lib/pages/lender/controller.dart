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

  List<RentalModel> availableRentals = [];
  List<RentalStatus> availableStatuses = <RentalStatus>[].obs;
  List<UserModel> availableUsers = [];
  List<MaterialModel> availableMaterial = [];

  @override
  Future<void> onInit() async {
    super.onInit();

    tabbBarController = TabController(length: 2, vsync: this);
    tabbBarController.addListener(() {
      tabBarIndex.value = tabbBarController.index;
    });

    availableUsers = await userController.getAllUsers();

    availableRentals = await rentalController.getAllRentals();
    filteredRentals.value = availableRentals;

    availableMaterial = await materialController.getAllMaterial();

    availableStatuses = await rentalController.getAllStatuses();

    for (RentalStatus item in availableStatuses) {
      statusOptions[item] = item.name;
    }
  }

  @override
  void onClose() {
    tabbBarController.dispose();
    super.onClose();
  }

  String getUserName(RentalModel item) {
    String userName = '${availableUsers.firstWhere(
            (UserModel user) => user.id == item.id).firstName} '
        '${availableUsers.firstWhere(
            (UserModel user) => user.id == item.id).lastName}';
    return userName;
  }

  String getMembershipNum(RentalModel item) {
    String membershipNum = availableUsers.firstWhere((UserModel user) =>
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

  String getMaterialPicture(RentalModel item, int materialIndex) {
    String path = availableMaterial.firstWhere((MaterialModel material) =>
    material.id == item.materialIds[materialIndex]).imagePath;
    return path;
  }

  String getItemName(RentalModel item, int materialIndex) {
    String itemName = availableMaterial.firstWhere((MaterialModel material) =>
    material.id == item.materialIds[materialIndex]).equipmentType.description;
    return itemName;
  }

  String getItemPrice(RentalModel item, int materialIndex) {
    String itemPrice = availableMaterial.firstWhere((MaterialModel material) =>
    material.id == item.materialIds[materialIndex]).rentalFee.toString();
    return itemPrice;
  }

  String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }
  
}
