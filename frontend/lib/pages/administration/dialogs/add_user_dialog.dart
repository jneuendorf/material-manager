import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/pages/administration/dialogs/edit_user_dialog.dart';


class AddUserDialog extends StatelessWidget {
  const AddUserDialog({super.key});

  static final administrationPageController = Get.find<AdministrationPageController>();

  @override
  Widget build(BuildContext context) => EditUserDialog(
    title: 'add_user'.tr, 
    onConfirm: (UserModel updatedUser) async {
      final int? id = await administrationPageController.userController.addUser(
        updatedUser);

      if (id == null) return false;

      UserModel user = UserModel(
        id: id,
        firstName: updatedUser.firstName,
        lastName: updatedUser.lastName,
        email: updatedUser.email,
        phone: updatedUser.phone,
        membershipNumber: updatedUser.membershipNumber,
        address: updatedUser.address,
        category: updatedUser.category,
        roles: updatedUser.roles,
    );

      administrationPageController.userController.users.add(user);

      return true;
    },
  );
}