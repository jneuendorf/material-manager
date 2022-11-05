import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/common/components/base_future_dialog.dart';


class CancelRentalDialog extends StatelessWidget {
  final RentalModel rental; 

  CancelRentalDialog({super.key, required this.rental});

  final RxBool loading = false.obs;

  @override
  Widget build(BuildContext context) => BaseFutureDialog(
    size: const Size(500.0, 340.0),
    loading: loading,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('cancel_reservation'.tr, 
                style: Get.textTheme.headline6,
              ),
            ),
            IconButton(
              splashRadius: 20,
              onPressed: Get.back,
              icon: const Icon(CupertinoIcons.xmark),
            ),
          ],
        ),
        const Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: CupertinoButton(
            onPressed: onCancelTap,
            color: Colors.red,
            child: Text('cancel'.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );

  Future<void> onCancelTap() async {
    loading.value = true;
    // TODO implement
    // execute cancel rental request
    loading.value = false;
    Get.back();
  }
}