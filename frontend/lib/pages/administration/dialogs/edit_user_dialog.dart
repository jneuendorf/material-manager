import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/common/components/base_future_dialog.dart';
import 'package:frontend/extensions/user/model.dart';


class EditUserDialog extends StatelessWidget {
  final UserModel user;

  EditUserDialog({super.key, required this.user});

  final RxBool loading = false.obs;

  @override
  Widget build(BuildContext context) => BaseFutureDialog(
    loading: loading,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('edit_user'.tr, style: Get.textTheme.headline6),
            ),
            IconButton(
              splashRadius: 20,
              onPressed: () {
                Get.back();
              },
              icon: const Icon(CupertinoIcons.xmark),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
      ],
    ), 
  );
}