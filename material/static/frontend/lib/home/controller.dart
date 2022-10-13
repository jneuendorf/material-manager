import 'package:get/get.dart';


const homeRoute = '/home';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

class HomeController extends GetxController {
  static const int navigatorKey = 0;

}