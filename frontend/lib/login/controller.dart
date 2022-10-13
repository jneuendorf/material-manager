import 'package:flutter/material.dart';
import 'package:frontend/home/controller.dart';

import 'package:get/get.dart';


const loginRoute = '/login';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool hideChars = true.obs;

  void toggleHideChars() {
    hideChars.value = !hideChars.value;
  }

  void login() {
    // TODO implement login
    Get.toNamed(homeRoute);
  } 
}