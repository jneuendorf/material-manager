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


  //variables for Sign-Up Page
  final PageController pageController = PageController();
  final TextEditingController membershipNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPasswordController = TextEditingController();
  final TextEditingController signupPasswordConfirmController = TextEditingController();

}
