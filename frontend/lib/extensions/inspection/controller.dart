import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/extensions/inspection/model.dart';
import 'package:frontend/extensions/inspection/mock_data.dart';
import 'package:frontend/common/util.dart';


class InspectionController extends GetxController {
  static final apiService = Get.find<ApiService>();

  final Completer initCompleter = Completer();

  // final RxList<InspectionModel> inspections = <InspectionModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    debugPrint('InspectionController init');

    initCompleter.future;

    // inspections.value = await getAllInspectionMocks();

    initCompleter.complete();
  }

  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<InspectionModel>> getAllInspectionMocks()  async {
    if (!isTest()) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return mockInspections + mockInspections;
  }

  /// Fetches the inspection corresponding to [id] from backend.
  Future<InspectionModel?> getInspection(int id) async {
    try {
      final response = await apiService.mainClient.get('/inspection/$id');

      if (response.statusCode != 200) debugPrint('Error getting inspections');

      return InspectionModel.fromJson(response.data);
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Fetches all comments to the corresponding [materialId] from backend.
  Future<List<Comment>?> getAllComments(int materialId) async {
    try {
      final response = await apiService.mainClient.get('/comments/$materialId');

      if (response.statusCode != 200) debugPrint('Error getting comments');

      return response.data.map<Comment>(
          (dynamic item) => Comment.fromJson(item)
      ).toList();
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Adds a new inspection to the backend.
  /// Returns the id of the newly created rental
  /// or null if an error occured.
  Future<int?> addInspection(InspectionModel inspection) async {
    try {
      final response = await apiService.mainClient.post('/inspection',
        data: {
          'inspector_id': inspection.inspectorId,
          // 'material_id': inspection.materialId,
          'date': inspection.date,
          // 'type': inspection.type.name,
          'comment': {
            // 'id': inspection.comment.id,
            // //'date': inspection.comment.date,
            // 'text': inspection.comment.text,
            // 'image_path': inspection.comment.imagePath,
          },
        },
      );

      if (response.statusCode != 201) debugPrint('Error adding inspection');

      return response.data['id'];
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Adds a new comment to the backend.
  /// Returns the id of the newly created rental
  /// or null if an error occured.
  Future<int?> addComment(Comment comment) async {
    try {
      final response = await apiService.mainClient.post('/inspection/comment',
        data: {
          //'date': comment.date,
          'text': comment.text,
          'image_path': comment.imagePath,
        },
      );

      if (response.statusCode != 201) debugPrint('Error adding comment');

      return response.data['id'];
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Updates a inspection in the backend.
  /// Returns true if the rental was updated successfully.
  Future<bool> updateInspection(InspectionModel inspection) async {
    try {
      final response = await apiService.mainClient.put('/inspection/${inspection.id}',
        data: {
          'inspector_id': inspection.inspectorId,
          // 'material_id': inspection.materialId,
          'date': inspection.date,
          // 'type': inspection.type.name,
          'comment': {
            // 'id': inspection.comment.id,
            // //'date': inspection.comment.date,
            // 'text': inspection.comment.text,
            // 'image_path': inspection.comment.imagePath,
          },
        },
      );

      if (response.statusCode != 200) debugPrint('Error updating inspection');

      return response.statusCode == 200;
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return false;
  }

  /// Updates a comment in the backend.
  /// Returns true if the rental was updated successfully.
  Future<bool> updateComment(Comment comment) async {
    try {
      final response = await apiService.mainClient.put('/inspection/comment/${comment.id}',
        data: {
          //'date': comment.date,
          'text': comment.text,
          'image_path': comment.imagePath,
        },
      );

      if (response.statusCode != 200) debugPrint('Error updating comment');

      return response.statusCode == 200;
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return false;
  }

}
