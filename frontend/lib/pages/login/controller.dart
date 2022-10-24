import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/pages/rental/controller.dart';
import 'package:get/get.dart';

const loginRoute = '/login';


class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}


class LoginController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final BoxConstraints constraints = const BoxConstraints(maxWidth: 500);

  final RxBool hideChars = true.obs;
  final RxBool rememberMe = false.obs;
  final RxString error = ''.obs;

  void toggleHideChars() {
    hideChars.value = !hideChars.value;
  }

  void toggleRememberMe(bool value) {
    rememberMe.value = value;
  }

  Future<void> login() async {
    try {
      var response = await apiService.mainClient.post('/login', data: {
          'email': emailController.text,
          'password': passwordController.text,
      });
      var accessToken = response.data['access_token'] as String;
      apiService.storeAccessToken(accessToken);
      if (rememberMe.isTrue) {
        // TODO: delete token on tear down
      }
      Get.toNamed(rentalRoute);
    } on DioError catch (e) {
      var response = e.response;
      if (response != null) {
        var statusCode = response.statusCode;
        if (statusCode != null && 400 <= statusCode && statusCode < 500) {
          error.value = (response.data['message'] as String).tr;
        } else {
          // TODO: Display unknown error
          error.value = 'An unknown error has occurred'.tr;
        }
      }
      else {
        debugPrint(e.message);
        error.value = 'An unknown error has occurred'.tr;
      }
      // TODO: uncomment after merge? What is it for?
      // apiService.defaultCatch(e);
    }
  }
}
