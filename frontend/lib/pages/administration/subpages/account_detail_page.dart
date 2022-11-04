import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/components/user_details_widget.dart';


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
        UserDetailsWidget(
          user: administrationPageController.selectedUser.value!,
        ),
        buildOrderList(),
      ],
    ),
  );

  Widget buildOrderList() => Container(); // TODO implement
}