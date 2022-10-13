import 'package:get/get.dart';


const lenderRoute = '/lender';

class LenderBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LenderController>(() => LenderController());
  }
}

class LenderController extends GetxController {}