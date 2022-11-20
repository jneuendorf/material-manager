import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/pages/profile/controller.dart';
import 'package:frontend/common/components/edit_user_dialog.dart';


class UpdateProfileDialog extends StatelessWidget {
  final UserModel user;

  const UpdateProfileDialog({super.key, required this.user});

  static final profilePageController = Get.find<ProfilePageController>();

  @override
  Widget build(BuildContext context) => EditUserDialog(
    title: 'edit_profile'.tr, 
    user: user, 
    showRoles: false,
    onConfirm: (UserModel updatedUser) async {
      final bool success = await profilePageController.userController.updateUser(
        updatedUser);

      if (!success) return false;

      profilePageController.currentUser.value = updatedUser;

      profilePageController.userController.users.removeWhere(
        (UserModel u) => u.id == updatedUser.id);

      profilePageController.userController.users.add(updatedUser);

      return true;
    }
  );
}