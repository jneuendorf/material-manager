import 'package:get/get.dart';


const profileRoute = '/profile';

class ProfilePageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}

class ProfileController extends GetxController {}