import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';


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

  Future<ApiService> init() async {
    Interceptor interceptor = InterceptorsWrapper(
      onRequest: (options, handler) async {
        // validate token
        if (kDebugMode) {
          print('Interceptor checking token validity');
          print(options);
          print(handler);
        }

        // if (aT != null) {
        //   options.headers['Authorization'] = 'Bearer $aT';
        // }
        return handler.next(options);
      },
    );

    mainClient.interceptors.add(interceptor);

    return this;
  }


}
