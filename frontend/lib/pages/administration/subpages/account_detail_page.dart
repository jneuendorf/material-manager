import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/pages/administration/dialogs/edit_user_dialog.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/buttons/text_icon_button.dart';


class AccountDetailPage extends StatelessWidget {
  const AccountDetailPage({super.key});

  static final administrationPageController = Get.find<AdministrationPageController>();

  @override
  Widget build(BuildContext context) => PageWrapper(
    showBackButton: !kIsWeb,
    pageTitle: !kIsWeb ? 'account_details'.tr : null,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kIsWeb) Text('account_details'.tr, 
          style: Get.textTheme.headline6!.copyWith(fontSize: 30),
        ),
        if (kIsWeb) Divider(endIndent: MediaQuery.of(context).size.width-250),
        const SizedBox(height: 16.0),
        Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Center(
                child: Text('${administrationPageController.selectedUser.value!.firstName[0]}${administrationPageController.selectedUser.value!.lastName[0]}',
                  style: Get.textTheme.headline3!.copyWith(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kIsWeb ? Row(
                  children: [
                    Text('${administrationPageController.selectedUser.value!.firstName} ${administrationPageController.selectedUser.value!.lastName}',
                      style: Get.textTheme.headline6,
                    ),
                    const SizedBox(width: 16.0),
                    Text(administrationPageController.selectedUser.value!.roles.map(
                      (Role r) => r.name).toList().join(', ')),
                  ],
                ) : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${administrationPageController.selectedUser.value!.firstName} ${administrationPageController.selectedUser.value!.lastName}',
                      style: Get.textTheme.headline6,
                    ),
                    Text(administrationPageController.selectedUser.value!.roles.map(
                      (Role r) => r.name).toList().join(', ')),
                  ],
                ),
                Text(administrationPageController.selectedUser.value!.email),
              ],
            ),
            const Spacer(),
            TextIconButton(
              onTap: () => Get.dialog(EditUserDialog(
                user: administrationPageController.selectedUser.value!,
                )), 
              iconData: Icons.edit,
              text: 'edit_profile'.tr,
              color: Get.theme.colorScheme.onSecondary,
            ),
          ],
        ),
        buildOrderList(),
      ],
    ),
  );

  Widget buildOrderList() => Container(); // TODO implement
}