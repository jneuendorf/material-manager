import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/extensions/rental/controller.dart';
import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/extensions/user/controller.dart';
import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/extensions/material/controller.dart';
import 'package:frontend/common/util.dart';


const lenderRoute = '/lender';

class LenderPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LenderPageController>(() => LenderPageController());
  }
}

class LenderPageController extends GetxController with GetSingleTickerProviderStateMixin {
  final apiService = Get.find<ApiService>();
  final rentalController = Get.find<RentalController>();
  final userController =  Get.find<UserController>();
  final materialController =  Get.find<MaterialController>();

  final RxInt tabBarIndex = 0.obs;
  late TabController tabbBarController;

  final RxList<RentalModel> activeRentals = <RentalModel>[].obs;
  final RxList<RentalModel> completedRentals = <RentalModel>[].obs;

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

    activeRentals.value = rentalController.rentals.where(
      (RentalModel rental) => rental.status != RentalStatus.returned
    ).toList();

    completedRentals.value = rentalController.rentals.where(
      (RentalModel rental) => rental.status == RentalStatus.returned
    ).toList();
  }

  @override
  void onClose() {
    tabbBarController.dispose();
    super.onClose();
  }

  String getUserName(RentalModel item) {
    UserModel user = userController.users.firstWhere(
      (UserModel user) => user.id == item.customerId);
    
    return '${user.firstName} ${user.lastName}';
  }

  String getMembershipNum(RentalModel item) {
    String membershipNum = userController.users.firstWhere((UserModel user) =>
      user.id == item.customerId).membershipNumber.toString();
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
    List<String> imageUrls = materialController.materials.firstWhere(
      (MaterialModel material) => material.id == item.materialIds[materialIndex]
    ).imageUrls;

    if (imageUrls.isEmpty) return null;

    return imageUrls.first;
  }

  String getItemName(RentalModel item, int materialIndex) {
    String itemName = materialController.materials.firstWhere(
      (MaterialModel material) => material.id == item.materialIds[materialIndex]
    ).materialType.name;
    return itemName;
  }

  String getItemPrice(RentalModel item, int materialIndex) {
    String itemPrice = materialController.materials.firstWhere(
      (MaterialModel material) => material.id == item.materialIds[materialIndex]
    ).rentalFee.toStringAsFixed(2);
    return itemPrice;
  }

  /// Handles change of the rental status.
  Future<void> onRentalStatusChanged(String newStatus, Rx<RentalModel> rental) async {
    RentalModel modifiedRental = RentalModel(
      id: rental.value.id,
      customerId: rental.value.customerId,
      materialIds: rental.value.materialIds,
      startDate: rental.value.startDate,
      endDate: rental.value.endDate,
      usageStartDate: rental.value.usageStartDate,
      usageEndDate: rental.value.usageEndDate,
      status: RentalStatus.values.byName(newStatus),
      lenderId: rental.value.lenderId,
      returnToId: rental.value.returnToId,
      createdAt: rental.value.createdAt, 
      cost: rental.value.cost,
      deposit: rental.value.deposit,
      discount: rental.value.discount,
    );


    if (modifiedRental.status == RentalStatus.lent) {
      modifiedRental.lenderId = apiService.tokenInfo!['sub'];
    } else if (modifiedRental.status == RentalStatus.returned) {
      modifiedRental.returnToId = apiService.tokenInfo!['sub'];
    }

    final bool success = await rentalController.updateRental(modifiedRental);

    if (success) {
      int rentalIndex = rentalController.rentals.indexWhere(
        (RentalModel item) => item.id == rental.value.id);
      rentalController.rentals[rentalIndex] = modifiedRental;

      rental.value = modifiedRental;
    }
  }

  /// Handles change of the rented material´s condition.
  Future<void> onMaterialConditionChanged(String newCondition, RentalModel rental, int materialId) async {
    MaterialModel material = materialController.materials.firstWhere(
      (MaterialModel material) => material.id == materialId);

    ConditionModel oldCondition = material.condition;
    material.condition = ConditionModel.values.byName(newCondition);

    final bool success = await materialController.updateMaterial(material);
    if (success) {
      int materialIndex = materialController.materials.indexWhere(
        (MaterialModel item) => item.id == material.id);
      materialController.materials[materialIndex] = material;
    } else {
      material.condition = oldCondition;
    }
  }

  String getMaterialCondition(int materialId) {
    ConditionModel condition = materialController.materials.firstWhere(
      (MaterialModel material) => material.id == materialId
    ).condition;

    return condition.name;
  }

}
