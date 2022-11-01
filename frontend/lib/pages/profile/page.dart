import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/user/mock_data.dart';
import 'package:frontend/pages/profile/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/components/user_details_widget.dart';


class ProfilePage extends GetView<ProfilePageController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PageWrapper(
    pageTitle: 'profile'.tr,
    child: Column(
      children: [
        Obx(() => UserDetailsWidget(user: controller.currentUser.value ?? mockUsers.first)),
      ],
    ),
  );
}