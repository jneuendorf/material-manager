import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/extensions/rental/mock_data_rental.dart';
import 'package:frontend/common/util.dart';


class RentalController extends GetxController {
  static final apiService = Get.find<ApiService>();

  final Completer initCompleter = Completer();

  final RxList<RentalModel> rentals = <RentalModel>[].obs;
  final RxList<RentalStatus> statuses = <RentalStatus>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    
    debugPrint('RentalController init');

    initCompleter.future;

    if (isTest()) {
      initCompleter.complete();
      return;
    }

    await Future.wait([
      _initRentals(),
    ]);

    initCompleter.complete();
  }

  Future<void> _initRentals() async {
    rentals.value = (await getAllRentals()) ?? [];
  }

  /// Fetches all rentals from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<RentalModel>> getAllRentalMocks()  async {
    if (!isTest()) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return mockRentals + mockRentals;
  }

  /// Fetches all rentals from backend.
  Future<List<RentalModel>?> getAllRentals() async {
    try {
      final response = await apiService.mainClient.get('/rentals');

      if (response.statusCode != 200) debugPrint('Error getting rentals');

      return response.data.map<RentalModel>(
        (dynamic item) => RentalModel.fromJson(item)
      ).toList();
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Adds the provided [rental] to the backend.
  /// Returns the id of the newly created rental
  /// or null if an error occured.
  Future<int?> addRental(RentalModel rental) async {

    try {
      final response = await apiService.mainClient.post('/rental',
        data: {
          'customer': {
            'id': rental.customerId!,
          },
          'materials': rental.materialIds.map((int id) => {'id': id}).toList(),
          'cost': rental.cost,
          'deposit': rental.deposit ?? 0,
          'created_at': rental.createdAt.toIso8601String(),
          'start_date': isoDateFormat.format(rental.startDate),
          'end_date': isoDateFormat.format(rental.endDate),
          'usage_start_date': isoDateFormat.format(
            rental.usageStartDate ?? rental.startDate),
          'usage_end_date': isoDateFormat.format(
            rental.usageEndDate ?? rental.endDate),
        },
      );

      if (response.statusCode != 201) debugPrint('Error adding rental');

      return response.data['id'];
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Updates the provided [rental] in the backend.
  /// Returns true if the rental was updated successfully.
  Future<bool> updateRental(RentalModel rental) async {
    try {
      final response = await apiService.mainClient.put('/rental/${rental.id}',
        data: {
          'customer': {
            'id': rental.customerId!,
          },
          if (rental.lenderId != null) 'lender': {
            'id': rental.lenderId!,
          },
          if (rental.returnToId != null) 'return_to': {
            'id': rental.returnToId!,
          },
          'materials': rental.materialIds.map((int id) => {'id': id}).toList(),
          'cost': rental.cost,
          'deposit': rental.deposit ?? 0,
          'created_at': rental.createdAt.toIso8601String(),
          'start_date': isoDateFormat.format(rental.startDate),
          'end_date': isoDateFormat.format(rental.endDate),
          'usage_start_date': isoDateFormat.format(
            rental.usageStartDate ?? rental.startDate),
          'usage_end_date': isoDateFormat.format(
            rental.usageEndDate ?? rental.endDate),
          if (rental.status != null) 'rental_status': rental.status!.name.toUpperCase(),
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
