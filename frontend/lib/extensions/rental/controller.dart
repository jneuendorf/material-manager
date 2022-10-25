import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/extensions/rental/mock_data_rental.dart';


class RentalController extends GetxController {
  static final apiService = Get.find<ApiService>();

  /// Fetches all rentals from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<RentalModel>> getAllRentals()  async {
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      await Future.delayed(const Duration(milliseconds: 500));
    }


    return mockRentals + mockRentals;
  }

  /// Fetches all rental statuses from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<RentalStatus>> getAllStatuses()  async {
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return [
      mockAvailibleRentalStatus,
      mockRentedRentalStatus,
      mockReturnedRentalStatus,
    ];
  }

  /// Adds a new rental to the backend.
  /// Returns the id of the newly created rental.
  Future<int?> addRental(RentalModel rental) async {
    try {
      final response = await apiService.mainClient.post('/rental',
        data: {
          'customer_id': rental.customerId,
          'material_ids': rental.materialIds,
          'cost': rental.cost,
          'created_at': rental.createdAt,
          'start_date': rental.startDate,
          'end_date': rental.endDate,
          'usage_start_date': rental.usageStartDate,
          'usage_end_date': rental.usageEndDate,
        },
      );

      if (response.statusCode != 201) debugPrint('Error adding rental');

      return response.data['id'];
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }
}
