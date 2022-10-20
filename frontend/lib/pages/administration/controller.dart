import 'package:get/get.dart';


const administrationRoute = '/administration';

class AdministrationPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdministrationPageController>(() => AdministrationPageController());
  }
}

class AdministrationPageController extends GetxController {}