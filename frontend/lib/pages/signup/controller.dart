import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:get/get.dart';

const signupRoute = '/signup';
const signupApiRoute = '/signup';

class SignupBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() => SignupController());
  }
}

class SignupController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final PageController pageController = PageController();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController membershipNumberController = TextEditingController();

  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController signupPasswordController = TextEditingController();
  final TextEditingController signupPasswordConfirmController = TextEditingController();

  final GlobalKey<FormState> membershipKey = GlobalKey<FormState>();
  final GlobalKey<FormState> addressKey = GlobalKey<FormState>();
  final GlobalKey<FormState> contactKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();


  Future<void> signup() async {
    try {
      await apiService.mainClient.post(signupApiRoute, data: {
          'email': signupEmailController.text,
          'password': signupPasswordController.text,
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'phone': phoneController.text,
          'membership_number': membershipNumberController.text,
          'street': streetNameController.text,
          'house_number': houseNumberController.text,
          'city': cityController.text,
          'zip_code': zipController.text,
      });
      Get.snackbar(
          'success'.tr,
          'signup_successful'.tr,
          duration: const Duration(seconds: 4),
        );
    } on DioError catch (e) {
      apiService.defaultCatch(e);
    }
  }

  // TODO: Where does this constraint come from?
  // set membership number on valid if length is 5
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
