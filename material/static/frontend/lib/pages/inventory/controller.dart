import 'package:get/get.dart';


const inventoryRoute = '/inventory';

class InventoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InventoryController>(() => InventoryController());
  }
}

class InventoryController extends GetxController {}