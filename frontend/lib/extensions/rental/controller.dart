import 'package:get/get.dart';

import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/extensions/rental/mock_data_rental.dart';


class RentalController extends GetxController {
  /// Fetches all rentals from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<RentalModel>> getAllRentals()  async {
    await Future.delayed(const Duration(milliseconds: 500));

    return mockRentals + mockRentals;
  }

  /// Fetches all rental statuses from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<RentalStatus>> getAllStatuses()  async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      mockAvailibleRentalStatus,
      mockRentedRentalStatus,
      mockReturnedRentalStatus,
    ];
  }
}
