import 'package:get/get.dart';

import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/pages/inspection/controller.dart';
import 'package:frontend/pages/inventory/controller.dart';
import 'package:frontend/pages/lender/controller.dart';
import 'package:frontend/pages/rental/controller.dart';


const homeRoute = '/home';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put<RentalController>(RentalController());
    Get.put<InventoryController>(InventoryController());
    Get.put<InspectionController>(InspectionController());
    Get.put<LenderController>(LenderController());
    Get.put<AdministrationController>(AdministrationController());
  }
}

class HomeController extends GetxController {
  static const int homeNavigatorKey = 0;
  static const int rentalNavigatorKey = 1;
}