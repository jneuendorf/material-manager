import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import 'package:get/get.dart';

import 'package:frontend/pages/inventory/controller.dart';
import 'package:frontend/common/components/dav_app_bar.dart';


class InventoryPage extends GetView<InventoryController> {
  const InventoryPage({Key? key}) : super(key: key);

 @override
  Widget build(BuildContext context) => Scaffold(
    appBar: kIsWeb ? DavAppBar() : null,
    body: Center(
      child: Text('inventory'.tr),
    ),
  );
}