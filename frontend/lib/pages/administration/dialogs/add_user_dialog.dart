import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/common/components/base_future_dialog.dart';


class AddUserDialog extends StatelessWidget {
  AddUserDialog({super.key});

  final RxBool loading = false.obs;

  @override
  Widget build(BuildContext context) => BaseFutureDialog(
    size: const Size(500.0, 325.0), 
    loading: loading,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('add_user'.tr, style: Get.textTheme.headline6),
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