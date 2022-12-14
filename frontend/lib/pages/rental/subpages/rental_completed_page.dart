import 'package:flutter/material.dart';
import 'package:frontend/common/util.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';


class RentalCompletedPage extends StatelessWidget {
  const RentalCompletedPage({super.key});

  static final rentalPageController = Get.find<RentalPageController>();

  @override
  Widget build(BuildContext context) => PageWrapper(
    pageTitle: isLargeScreen(context) ? null : 'reservation_completed'.tr,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('reservation_completed'.tr, 
          style: Get.textTheme.headline6!.copyWith(fontSize: 30),
        ),
        const Divider(),
        // TODO add PDF-invoice and download button
      ],
    ),
  );
}