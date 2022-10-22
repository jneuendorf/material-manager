import 'package:get/get.dart';

import 'package:frontend/extensions/user/mock_data.dart';
import 'package:frontend/extensions/user/model.dart';


class UserController extends GetxController {
  /// Fetches all users from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<List<UserModel>> getAllUsers()  async {
    await Future.delayed(const Duration(milliseconds: 500));

    return mockUsers+ mockUsers;
  }

  Future<List<Role>> getAllRoles() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      mockAdministratiorRole,
      mockIncpectorRole,
      mockIncpectorRole,
      mockBasicRole,
    ];
  }

}
