import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/extensions/user/controller.dart';


const profileRoute = '/profile';

class ProfilePageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePageController>(() => ProfilePageController());
  }
}

class ProfilePageController extends GetxController {
  final userController = Get.find<UserController>();

  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  @override
  Future<void> onInit() async {
    super.onInit();

    int? uid = UserController.apiService.tokenInfo?['sub'] ?? 1;

    if (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')) return;

    currentUser.value = await userController.getUser(uid!);
  }
}