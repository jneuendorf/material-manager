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
    await Future.delayed(const Duration(milliseconds: 500));

    return mockUsers+ mockUsers;
  }

  /// Fetches all roles from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<Role>> getAllRoles() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      mockAdministratiorRole,
      mockInspectorRole,
      mockInstructorRole,
      mockBasicRole,
    ];
  }

  Future<List<Right>> getAllRights() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      mockAdministrationRight,
      mockLenderRight,
      mockInventoryRight,
      mockInspectionRight,
    ];
  }

  /// Adds a new user to the backend.
  /// Currently only a mock request is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<int?> addRole(Role role) async {
    try {
      final response = await apiService.mainClient.post(
        '/role',
        data: {
          'name': role.name,
          'description': role.description,
          'rights': role.rights.map((Right r) => {
            'id': r.id,
            'name': r.name,
            'description': r.description,
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
