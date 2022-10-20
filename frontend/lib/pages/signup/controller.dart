import 'package:flutter/material.dart';

import 'package:get/get.dart';


const signupRoute = '/signup';

class SignupBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() => SignupController());
  }
}

class SignupController extends GetxController {
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


  final GlobalKey<FormState> membershipKey = GlobalKey<FormState>();
  final GlobalKey<FormState> addressKey = GlobalKey<FormState>();
  final GlobalKey<FormState> contactKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();


  void signup() {
    // TODO implement signup
  }

  //set membership number on valid if lenght is 5
  String? validateMembershipNumber(String? value) {
    if(value!.isEmpty) {
      return 'membership_num_is_mandatory'.tr;
    }
    final membershipNum = RegExp(r'\d{5}');
    if(!membershipNum.hasMatch(value)){
      return 'invalid_membership_num'.tr;
    }
    return null;
  }

  // Allows a name with an initial capital letter and any length
  String? validateName(String? value) {
    if(value!.isEmpty) {
      return 'name_is_mandatory'.tr;
    }
    return null;
  }

  String? validateStreet(String? value) {
    if(value!.isEmpty) {
      return 'street_is_mandatory'.tr;
    }
    return null;
  }



  String? validateCity(String? value) {
    if(value!.isEmpty) {
      return 'city_is_mandatory'.tr;
    }
    return null;
  }


  String? validateHouseNumber(String? value) {
    if(value!.isEmpty) {
      return 'housenumber_is_mandatory'.tr;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if(value!.isEmpty) {
      return 'password_is_mandatory'.tr;
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if(value!.isEmpty) {
      return 'password_is_mandatory'.tr;
    }
    var password = signupPasswordController.text;
    if(password != value.toString()){
      return 'passwords_not_equal'.tr;
    }
    return null;
  }
}