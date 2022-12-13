import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/api.dart';
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
  final ApiService apiService = Get.find<ApiService>();
  final userController = Get.find<UserController>();
  final rentalController = Get.find<RentalController>();

  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxList<RentalModel> currentRentals = <RentalModel>[].obs;

  final RxString selectedLanguage = Get.locale?.languageCode.obs ?? 'en'.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    int? uid = apiService.tokenInfo?['sub'] ?? 1;

    if (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')) return;

    currentUser.value = await userController.getUser(uid!);

    await rentalController.initCompleter.future;

    currentRentals.value = rentalController.rentals; // TODO should be the users rentals only
  }

  /// Handles the language change.
  Future<void> onLanguageChanged(String? value) async {
    if (value == null) return;

    selectedLanguage.value = value;

    await Get.updateLocale(Locale(value));

    await storage.write(key: 'locale', value: value);
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