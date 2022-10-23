import 'package:get/get.dart';

import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/extensions/rental/mock_data_rental.dart';


class RentalController extends GetxController {
  Future<List<RentalModel>> getAllRentals()  async {
    await Future.delayed(const Duration(milliseconds: 500));

    return mockRentals+ mockRentals;
  }
}
