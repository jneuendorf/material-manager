import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

const jwtStorageKey = 'jwt';
const storage = FlutterSecureStorage();
// TODO: Or `const bool prod = const bool.fromEnvironment('dart.vm.product');`?
//  See https://stackoverflow.com/questions/49707028/
const baseUrl = kDebugMode ? 'http://localhost:5000' : '';
// const authUrl = '';


class ApiService extends GetxService {
  final Dio mainClient = Dio(BaseOptions(
    baseUrl: baseUrl,
  ));

  // final Dio authClient = Dio(BaseOptions(
  //   baseUrl: authUrl,
  // ));

  Future<String?> getAccessToken() async {
    return await storage.read(key: jwtStorageKey);
  }

  Future<void> storeAccessToken(String accessToken) async {
    await storage.write(key: jwtStorageKey, value: accessToken);
  }

  Future<ApiService> init() async {
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
}
