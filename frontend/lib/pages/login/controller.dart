import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
      var response = await apiService.mainClient.post(
        '/login',
        data: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );
      var statusCode = response.statusCode;
      var responseData = response.data;
      // TODO: What do we do if the status code is null?
      if (statusCode != null) {
        if (statusCode == 200) {
          var accessToken = responseData['access_token'] as String;
          if (kDebugMode) {
            print(accessToken);
            // TODO: Store token
          }
          Get.toNamed(rentalRoute);
        } else if (400 <= statusCode && statusCode < 500) {
          error.value = (responseData['message'] as String).tr;
        } else {
          // TODO: Display unknown error
          error.value = 'An unknown error has occurred'.tr;
        }
      }
    } on DioError catch (e) {
      // TODO: uncomment after merge
      // apiService.defaultCatch(e);
    }
  }
}
