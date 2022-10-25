import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/extensions/user/mock_data.dart';
import 'package:frontend/extensions/user/model.dart';


class UserController extends GetxController {
  static final apiService = Get.find<ApiService>();

  /// Fetches all users from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<UserModel>> getAllUsers()  async {
    if (!kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST')) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return mockUsers+ mockUsers;
  }

  /// Fetches all roles from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<Role>> getAllRoles() async {
    if (!kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST')) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return [
      mockAdministratiorRole,
      mockInspectorRole,
      mockInstructorRole,
      mockBasicRole,
    ];
  }

  Future<List<Permission>> getAllPermissions() async {
    if (!kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST')) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return [
      mockAdministrationPermission,
      mockLenderPermission,
      mockInventoryPermission,
      mockInspectionPermission,
    ];
  }

  /// Adds a new user to the backend.
  /// Returns the id of the newly created role.
  Future<int?> addRole(Role role) async {
    try {
      final response = await apiService.mainClient.post(
        '/role',
        data: {
          'name': role.name,
          'description': role.description,
          'permissions': role.permissions.map((Permission p) => {
            'id': p.id,
            'name': p.name,
            'description': p.description,
          }).toList(),
        },
      );

      if (response.statusCode != 201) debugPrint('Error adding role');

      return response.data['id'];
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

}
