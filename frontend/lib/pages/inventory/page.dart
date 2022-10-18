import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/inventory/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';


class InventoryPage extends GetView<InventoryController> {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PageWrapper(
    child: Center(
      child: Text('inventory'.tr),
    ),
  );
}