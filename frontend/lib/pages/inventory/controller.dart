import 'package:get/get.dart';


const inventoryRoute = '/inventory';

class InventoryPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InventoryPageController>(() => InventoryPageController());
  }
}

class InventoryPageController extends GetxController {}