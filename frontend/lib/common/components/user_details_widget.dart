import 'package:flutter/material.dart';
import 'package:frontend/common/util.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/user/controller.dart';
import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/common/buttons/text_icon_button.dart';
import 'package:frontend/pages/administration/dialogs/edit_user_dialog.dart';


class UserDetailsWidget extends StatelessWidget {
  final UserModel? user;
  final bool showLogoutButton;
  
  const UserDetailsWidget({
    super.key, 
    required this.user, 
    this.showLogoutButton = false,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(
        radius: 40.0,
        child: user!= null ? Center(
          child: Text('${user?.firstName[0]}${user?.lastName[0]}',
            style: Get.textTheme.headline3!.copyWith(color: Colors.black),
          ),
        ) : null,
      ),
      const SizedBox(width: 16.0),
      if (user != null) Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isLargeScreen(context) ? Row(
            children: [
              Text('${user?.firstName} ${user?.lastName}',
                style: Get.textTheme.headline6,
              ),
              const SizedBox(width: 16.0),
              Text(user!.roles.map(
                (Role r) => r.name).toList().join(', ')),
            ],
          ) : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${user?.firstName} ${user?.lastName}',
                style: Get.textTheme.headline6,
              ),
              Text(user!.roles.map(
                (Role r) => r.name).toList().join(', ')),
            ],
          ),
          Text(user!.email),
        ],
      ),
      if (showLogoutButton) const Spacer(),
      if (showLogoutButton) TextButton(
        onPressed: Get.find<UserController>().logout, 
        child: Text('logout'.tr),
      ),
      const Spacer(),
      TextIconButton(
        onTap: () {
          if (user == null) return;
          Get.dialog(EditUserDialog(user: user!));
        }, 
        iconData: Icons.edit,
        text: 'edit_profile'.tr,
        color: Get.theme.colorScheme.onSecondary,
      ),
    ],
  );
}