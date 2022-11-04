import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/extensions/user/controller.dart';


const loginRoute = '/login';
const afterLoginRoute = rentalRoute;

class LoginPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class LoginController extends GetxController {
  final userController = Get.find<UserController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final BoxConstraints constraints = const BoxConstraints(maxWidth: 500);

  final RxBool hideChars = true.obs;
  final RxBool rememberMe = false.obs;

  void toggleHideChars() {
    hideChars.value = !hideChars.value;
  }

  void toggleRememberMe(bool value) {
    rememberMe.value = value;
  }

  /// Handles a tap on the login button.
  Future<void> onLoginTap() async {
    if (!formKey.currentState!.validate()) return; 
    
    final String email = emailController.text;
    final String password = passwordController.text;

    final bool loginSuccessful = await userController.login(email, password);

    if (rememberMe.isTrue) {
      // TODO: delete token on tear down
    }

    if (loginSuccessful) {
      Get.offAllNamed(afterLoginRoute);
    }
  }

}
