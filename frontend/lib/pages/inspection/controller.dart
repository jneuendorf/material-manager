import 'package:get/get.dart';


const inspectionRoute = '/inspection';

class InspectionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InspectionController>(() => InspectionController());
  }
}

class InspectionController extends GetxController {}