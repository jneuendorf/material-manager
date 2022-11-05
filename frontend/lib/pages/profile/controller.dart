import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/extensions/user/controller.dart';
import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/extensions/rental/controller.dart';


const profileRoute = '/profile';

class ProfilePageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePageController>(() => ProfilePageController());
  }
}

class ProfilePageController extends GetxController {
  final userController = Get.find<UserController>();
  final rentalController = Get.find<RentalController>();

  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxList<RentalModel> currentRentals = <RentalModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    int? uid = UserController.apiService.tokenInfo?['sub'] ?? 1;

    if (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')) return;

    currentUser.value = await userController.getUser(uid!);

    currentRentals.value = rentalController.rentals; // TODO should be the users rentals only
  }

  String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  Color getDataRowColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };

    if (states.any(interactiveStates.contains)) {
      return Get.theme.colorScheme.primary.withOpacity(0.12);
    }

    return Colors.transparent;
  }
}