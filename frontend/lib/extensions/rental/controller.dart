import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/extensions/rental/mock_data_rental.dart';


class RentalController extends GetxController {
  static final apiService = Get.find<ApiService>();

  final RxList<RentalModel> rentals = <RentalModel>[].obs;
  final RxList<RentalStatus> statuses = <RentalStatus>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    
    debugPrint('RentalController init');

    rentals.value = await getAllRentalMocks();
    statuses.value = await getAllStatusMocks();
  }

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
  /// The [customerId] will automaically be added to [rental].
  /// The [ApiService]´s [tokenInfo] must not be null.
  Future<int?> addRental(RentalModel rental) async {
    assert(apiService.tokenInfo != null);

    try {
      final response = await apiService.mainClient.post('/rental',
        data: {
          'customer_id': apiService.tokenInfo!['sub'],
          'material_ids': rental.materialIds,
          'cost': rental.cost,
          'created_at': rental.createdAt.toIso8601String(),
          'start_date': rental.startDate.toIso8601String(),
          'end_date': rental.endDate.toIso8601String(),
          'usage_start_date': rental.usageStartDate.toIso8601String(),
          'usage_end_date': rental.usageEndDate.toIso8601String(),
          if (rental.status != null) 'status': {
            'id': rental.status!.id,
            'name': rental.status!.name,
          },
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
          'created_at': rental.createdAt.toIso8601String(),
          'start_date': rental.startDate.toIso8601String(),
          'end_date': rental.endDate.toIso8601String(),
          'usage_start_date': rental.usageStartDate.toIso8601String(),
          'usage_end_date': rental.usageEndDate.toIso8601String(),
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
