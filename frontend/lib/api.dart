import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


const jwtStorageKey = 'jwt';
const storage = FlutterSecureStorage();
// TODO: Or `const bool prod = const bool.fromEnvironment('dart.vm.product');`?
//  See https://stackoverflow.com/questions/49707028/
const baseUrl = kDebugMode ? 'http://localhost:5000' : '';
// const authUrl = 'http://localhost:5000/auth';
Map<int, String> defaultErrors = {
  400: 'bad_request'.tr,
  401: 'unauthorized'.tr,
  403: 'forbidden'.tr,
};

class ApiService extends GetxService {
  final Dio mainClient = Dio(BaseOptions(
    baseUrl: baseUrl,
  ));

  // final Dio authClient = Dio(BaseOptions(
  //   baseUrl: authUrl,
  // ));

  Future<String?> getAccessToken() async {
    // checks if running a test and return null since 
    //[FlutterSecureStorage] cant be accessed in tests.
    if (!kIsWeb &&  Platform.environment.containsKey('FLUTTER_TEST')) return null;
    return await storage.read(key: jwtStorageKey);
  }

  Future<void> storeAccessToken(String accessToken) async {
    await storage.write(key: jwtStorageKey, value: accessToken);
  }

  /// Needed so the token can be accessed from everywhere in the app.
  /// tokenInfo should contain userId, email, and roles/permissions.
  late final Map<String, dynamic>? tokenInfo;

  Future<ApiService> init() async {
    final String? accessToken = await getAccessToken();
    if (accessToken != null) {
      tokenInfo = JwtDecoder.decode(accessToken);
    }

    Interceptor interceptor = InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Insert JWT access token into the request
        String? accessToken = await getAccessToken();
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
    );

    mainClient.interceptors.add(interceptor);
    return this;
  }

  void defaultCatch(DioError e) {
    debugPrint('defaultCatch error: $e');
    var response = e.response;
    if (response != null) {
      var statusCode = response.statusCode;
      if (statusCode != null && 400 <= statusCode && statusCode < 500) {
        String message;
        try {
          message = response.data['message'];
        } catch(e) {
          message = defaultErrors[statusCode]!;
        }
        Get.snackbar(
          'error'.tr,
          message.tr,
          duration: const Duration(seconds: 4),
        );
      }
      else {
        Get.snackbar('error'.tr, 'unknown_error_occurred'.tr);
      }
    } else {
      debugPrint('no response error: $e');
      Get.snackbar(
        'network_error'.tr,
        'network_error_occurred'.tr,
        duration: const Duration(seconds: 4),
      );
    }
  }
}
