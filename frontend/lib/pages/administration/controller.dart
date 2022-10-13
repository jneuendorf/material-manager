import 'package:get/get.dart';


const administrationRoute = '/administration';

class AdministrationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdministrationController>(() => AdministrationController());
  }
}

class AdministrationController extends GetxController {}