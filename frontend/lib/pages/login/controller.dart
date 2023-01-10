import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:frontend/api.dart';
import 'package:frontend/pages/rental/controller.dart';


const loginRoute = '/login';
String afterLoginRoute = rentalRoute;

class LoginPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class LoginController extends GetxController {
  final apiService = Get.find<ApiService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool hideChars = true.obs;
  final RxBool rememberMe = false.obs;

  /// Returns a Map containing access and refresh token if successful.
  Future<Map<String,String>?> login() async {
    try {
      final response = await apiService.authClient.post('/login', data: {
        'email': emailController.text,
        'password': passwordController.text,
      });
      var accessToken = response.data['access_token'] as String;
      var refreshToken = response.data['refresh_token'] as String;

      apiService.tokenInfo = JwtDecoder.decode(accessToken);
      apiService.accessToken = accessToken;
      apiService.refreshToken = refreshToken;
      apiService.saveCredentials = rememberMe.value;


      return {
        atStorageKey: accessToken,
        rtStorageKey: refreshToken,
      };
    } on DioError catch (e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Handles a tap on the login button.
  Future<void> onLoginTap() async {
    if (!formKey.currentState!.validate()) return; 

    final Map<String,String>? tokens = await login();

    if (tokens == null) return;

    if (rememberMe.value) {
      await storeAccessToken(tokens[atStorageKey]!);
      await storeRefreshToken(tokens[rtStorageKey]!);
    }

    if (afterLoginRoute == rentalRoute) {
      Get.offAllNamed(rentalRoute);
    } else {
      Get.back();
    }
  }

  void toggleHideChars() {
    hideChars.value = !hideChars.value;
  }

  void toggleRememberMe(bool value) {
    rememberMe.value = value;
  }

}
