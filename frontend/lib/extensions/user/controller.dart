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
  Future<List<UserModel>> getAllUserMocks()  async {
    if (!kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST')) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return mockUsers + mockUsers;
  }

  /// Fetches all roles from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<Role>> getAllRoleMocks() async {
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

  /// Fetches all permissoins from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<Permission>> getAllPermissionMocks() async {
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

  /// Fetches all users from backend.
  Future<List<UserModel>?> getAllUsers() async {
    try {
      final response = await apiService.mainClient.get('/user');

      if (response.statusCode != 200) debugPrint('Error getting users');

      return response.data['users'].map(
        (dynamic item) => UserModel.fromJson(item)
      ).toList();
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Fetches all roles from backend.
  Future<List<Role>?> getAllRoles() async {
    try {
      final response = await apiService.mainClient.get('/role');

      if (response.statusCode != 200) debugPrint('Error getting roles');

      return response.data['roles'].map(
        (dynamic item) => Role.fromJson(item)
      ).toList();
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Fetches all permissions from backend.
  Future<List<Permission>?> getAllPermissions() async {
    try {
      final response = await apiService.mainClient.get('/permission');

      if (response.statusCode != 200) debugPrint('Error getting permissions');

      return response.data['permissions'].map(
        (dynamic item) => Permission.fromJson(item)
      ).toList();
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
  }

  /// Adds a new user to the backend.
  /// Returns the id of the newly created user.
  Future<int?> addUser(UserModel user) async {
    try {
      final response = await apiService.mainClient.post('/user', 
        data: {
          'first_name': user.firstName,
          'last_name': user.lastName,
          'email': user.email,
          'phone': user.phone,
          'membership_number': user.membershipNumber,
          'address': {
            'street': user.address.street,
            'house_number': user.address.houseNumber,
            'city': user.address.city,
            'zip': user.address.zip,
          },
          'category': user.category,
          'roles': user.roles.map((Role r) => {
            'id': r.id,
            'name': r.name,
            'description': r.description,
            'permissions': r.permissions.map((Permission p) => {
              'id': p.id,
              'name': p.name,
              'description': p.description,
            }).toList(),
          }).toList(),
        },
      );

      if (response.statusCode != 200) debugPrint('Error adding user');

      return response.data['id'];
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return null;
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

  /// Updates a user in the backend.
  /// Returns true if the user was updated successfully.
  Future<bool> updateUser(UserModel user) async {
    try {
      final response = await apiService.mainClient.put('/user/${user.id}',
        data: {
          'first_name': user.firstName,
          'last_name': user.lastName,
          'email': user.email,
          'phone': user.phone,
          'membership_number': user.membershipNumber,
          'address': {
            'street': user.address.street,
            'house_number': user.address.houseNumber,
            'city': user.address.city,
            'zip': user.address.zip,
          },
          'category': user.category,
          'roles': user.roles.map((Role r) => {
            'id': r.id,
            'name': r.name,
            'description': r.description,
            'permissions': r.permissions.map((Permission p) => {
              'id': p.id,
              'name': p.name,
              'description': p.description,
            }).toList(),
          }).toList(),
        },
      );

      if (response.statusCode != 200) debugPrint('Error updating user');

      return response.statusCode == 200;
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return false;
  }

  /// Updates a role in the backend.
  /// Returns true if the role was updated successfully.
  Future<bool> updateRole(Role role) async {
    try {
      final response = await apiService.mainClient.put('/role/${role.id}',
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

      if (response.statusCode != 200) debugPrint('Error updating role');

      return response.statusCode == 200;
    } on DioError catch(e) {
      apiService.defaultCatch(e);
    }
    return false;
  }
}
