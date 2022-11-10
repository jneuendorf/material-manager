import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';

import 'package:frontend/extensions/user/mock_data.dart';
import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/pages/profile/controller.dart';
import 'package:frontend/pages/profile/dialogs/cancel_rental_dialog.dart';
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
        Obx(() => UserDetailsWidget(
          user: controller.currentUser.value ?? mockUsers.first,
          showLogoutButton: true,
        )),
        UserOrderList(
            user: controller.currentUser.value ?? mockUsers.first,
        )
      ],
    ),
  );
}
