import 'package:get/get.dart';


const lenderRoute = '/lender';

class LenderPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LenderPageController>(() => LenderPageController());
  }
}

class LenderPageController extends GetxController {}