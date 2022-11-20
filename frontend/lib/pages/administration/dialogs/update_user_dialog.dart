import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/pages/administration/dialogs/edit_user_dialog.dart';



class UpdateUserDialog extends StatelessWidget {
  final UserModel user;

  const UpdateUserDialog({super.key, required this.user});

  static final administrationPageController = Get.find<AdministrationPageController>();

  @override
  Widget build(BuildContext context) => EditUserDialog(
    title: 'edit_user'.tr, 
    user: user, 
    onConfirm: (UserModel updatedUser) async {
      final bool success = await administrationPageController.userController.updateUser(
        updatedUser);

      if (!success) return false;

      administrationPageController.userController.users.removeWhere(
        (UserModel u) => u.id == updatedUser.id);

      administrationPageController.userController.users.add(updatedUser);

      return true;
    }
  );
}