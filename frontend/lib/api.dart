import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:get/get.dart';


const baseUrl = 'http://localhost:5000';
const authUrl = 'http://localhost:5000/auth';

class ApiService extends GetxService {
  final Dio mainClient = Dio(BaseOptions(
    baseUrl: baseUrl,
  ));

  final Dio authClient = Dio(BaseOptions(
    baseUrl: authUrl,
  ));

  Future<ApiService> init() async {
    Interceptor interceptor = InterceptorsWrapper(
      onRequest: (options, handler) async {
        // vlaidate token
        //print('Interceptor checking token validity');
        
        // if (aT != null) {
        //   options.headers['Authorization'] = 'Bearer $aT';
        // }
        return handler.next(options);
      },
    );

    mainClient.interceptors.add(interceptor);

    return this;
  }

  void defaultCatch(DioError e) {
    debugPrint('defaultCatch error: $e');
    if (e.response != null) {
      debugPrint(e.response!.data);
      switch (e.response!.data['error']) {
        case 'unauthorized':
          debugPrint('unauthorized');
          //Get.offNamed(loginRoute);
          break;
        default:
          Get.snackbar('error'.tr, 'unknown_error_occured'.tr);
          break;
      }
    } else {
      debugPrint('no response error: $e');
      Get.snackbar('network_error'.tr, 'network_error_occured'.tr, 
        duration: const Duration(seconds: 2));
    }
  }

}