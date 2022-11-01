import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:frontend/pages/login/controller.dart';


const atStorageKey = 'access_token';
const rtStorageKey = 'refresh_token';
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

  final Dio authClient = Dio(BaseOptions(
    baseUrl: baseUrl,
  ));

  /// Needed so the token can be accessed from everywhere in the app.
  /// tokenInfo should contain userId, email, and roles/permissions.
  late final Map<String, dynamic>? tokenInfo;

  Future<ApiService> init() async {
    final String? accessToken = await getAccessToken();
    if (accessToken != null) {
      tokenInfo = JwtDecoder.decode(accessToken);
    } else {
      tokenInfo = {};
    }

    Interceptor interceptor = InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Insert JWT access token into the request
        String? accessToken = await checkAndGetRefreshIfExpired();
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

  /// Checks if the accessToken is valid and returns it if it is.
  /// Otherwise it refreshes the accessToken and returns it.
  /// In case of error null is returned,
  Future<String?> checkAndGetRefreshIfExpired() async {
    String? accessToken = await getAccessToken();
    String? refreshToken = await getRefreshToken();

    if (accessToken != null && refreshToken != null &&
    JwtDecoder.getRemainingTime(accessToken) < const Duration(minutes: 1) &&
    !JwtDecoder.isExpired(refreshToken)) {
      // refresh access token
      debugPrint('refreshing access token');
      try {
        final response = await authClient.post('/refresh',
          options: Options(
            headers: {
              'Authorization': 'Bearer $refreshToken',
            }
          ),
        );

        accessToken = response.data['access_token'];
        storeAccessToken(accessToken!);
      } on DioError catch(e) {
        debugPrint('error on refresh of accessToken: $e');
        if (e.response != null) {
          switch (e.response!.data['error']) {
            case 'unauthorized': {
              await storage.delete(key: atStorageKey);
              await storage.delete(key: rtStorageKey);
              Get.offNamed(loginRoute);
            }
            break;
            default: {
              Get.snackbar('Fehler', 'Ein unbekannter Fehler ist aufgetreten');
            }
            break;
          }
        } else {
          Get.snackbar(
            'network_error'.tr,
            'network_error_occurred'.tr,
            duration: const Duration(seconds: 4),
          ); 
        }
        return null;
      }
    }
    return accessToken;
  }

  /// Returns the accessToken from the secure storage, if found.
  Future<String?> getAccessToken() async {
    // checks if running a test and return null since 
    //[FlutterSecureStorage] cant be accessed in tests.
    if (!kIsWeb &&  Platform.environment.containsKey('FLUTTER_TEST')) return null;
    return await storage.read(key: atStorageKey);
  }

  /// Returns the refreshToken from the secure storage, if found.
  Future<String?> getRefreshToken() async {
    // checks if running a test and return null since 
    //[FlutterSecureStorage] cant be accessed in tests.
    if (!kIsWeb &&  Platform.environment.containsKey('FLUTTER_TEST')) return null;
    return await storage.read(key: rtStorageKey);
  }

  Future<void> storeAccessToken(String accessToken) async {
    await storage.write(key: atStorageKey, value: accessToken);
  }

  Future<void> storeRefreshToken(String refreshToken) async {
    await storage.write(key: rtStorageKey, value: refreshToken);
  }

}
