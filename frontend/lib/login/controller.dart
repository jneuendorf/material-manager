import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/rental/controller.dart';


const loginRoute = '/login';
const signupRoute = '/signup';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final BoxConstraints constraints = const BoxConstraints(maxWidth: 500);

  final RxBool hideChars = true.obs;
  final RxBool rememberMe = false.obs;

  void toggleHideChars() {
    hideChars.value = !hideChars.value;
  }

  void toogleRememberMe(bool value) {
    rememberMe.value = value;
  }

  void login() {
    // TODO implement login
    Get.toNamed(rentalRoute);
  } 
}