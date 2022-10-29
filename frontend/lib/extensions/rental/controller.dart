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
  Future<List<RentalModel>> getAllRentalMocks()  async {
    if (!kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST')) {
      await Future.delayed(const Duration(milliseconds: 500));
    }


    return mockRentals + mockRentals;
  }

  /// Fetches all rental statuses from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<RentalStatus>> getAllStatusMocks()  async {
    if (!kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST')) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return [
      mockAvailibleRentalStatus,
      mockRentedRentalStatus,
      mockReturnedRentalStatus,
    ];
  }

  /// Fetches all rentals from backend.
  Future<List<RentalModel>?> getAllRentals() async {
    try {
      final response = await apiService.mainClient.get('/rental');

      if (response.statusCode != 200) debugPrint('Error getting rentals');

      return response.data['rentals'].map(
        (dynamic item) => RentalModel.fromJson(item)
      ).toList();
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Fetches all rental statuses from backend.
  Future<List<RentalStatus>?> getAllStatuses() async {
    try {
      final response = await apiService.mainClient.get('/rental/status');

      if (response.statusCode != 200) debugPrint('Error getting rental statuses');

      return response.data['rentalStatuses'].map(
        (dynamic item) => RentalStatus.fromJson(item)
      ).toList();
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Adds a new rental to the backend.
  /// Returns the id of the newly created rental
  /// or null if an error occured.
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

  /// Updates a rental in the backend.
  /// Returns true if the rental was updated successfully.
  Future<bool> updateRental(RentalModel rental) async {
    try {
      final response = await apiService.mainClient.put('/rental/${rental.id}',
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

      if (response.statusCode != 200) debugPrint('Error updating rental');

      return response.statusCode == 200;
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return false;
  }
}
