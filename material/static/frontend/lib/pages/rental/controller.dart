import 'package:get/get.dart';


const rentalRoute = '/rental';

class RentalBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RentalController>(() => RentalController());
  }
}

class RentalController extends GetxController {}