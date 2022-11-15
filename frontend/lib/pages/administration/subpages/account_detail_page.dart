import 'package:flutter/material.dart';
import 'package:frontend/common/util.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/components/user_details_widget.dart';
import 'package:frontend/common/components/user_order_list.dart';


class AccountDetailPage extends StatelessWidget {
  const AccountDetailPage({super.key});

  static final administrationPageController = Get.find<AdministrationPageController>();

  @override
  Widget build(BuildContext context) => PageWrapper(
    showBackButton: !isLargeScreen(context),
    pageTitle: !isLargeScreen(context) ? 'account_details'.tr : null,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLargeScreen(context)) Text('account_details'.tr,
          style: Get.textTheme.headline6!.copyWith(fontSize: 30),
        ),
        if (isLargeScreen(context)) Divider(endIndent: MediaQuery.of(context).size.width-250),
        const SizedBox(height: 16.0),
        UserDetailsWidget(
          user: administrationPageController.selectedUser.value!,
        ),
        UserOrderList(
          user: administrationPageController.selectedUser.value!,
        ),
      ],
    ),
  );
}
