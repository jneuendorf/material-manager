import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/user/mock_data.dart';
import 'package:frontend/pages/profile/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/components/user_details_widget.dart';
import 'package:frontend/common/components/user_order_list.dart';


class ProfilePage extends GetView<ProfilePageController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PageWrapper(
    pageTitle: 'profile'.tr,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Obx(() => DropdownButton<String>(
            value: controller.selectedLanguage.value,
            icon: const Icon(Icons.arrow_drop_down),
            borderRadius: BorderRadius.circular(8.0),
            onChanged: (String? value) {
              if (value != null) {
                Get.updateLocale(Locale(value));
                controller.selectedLanguage.value = value;
              }
            },
            items: ['de', 'en'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )),
        ),
        Obx(() => UserDetailsWidget(
          user: controller.currentUser.value ?? mockUsers.first,
          showLogoutButton: true,
        )),
        Obx(() => UserOrderList(
            user: controller.currentUser.value ?? mockUsers.first,
        )),
      ],
    ),
  );
}
