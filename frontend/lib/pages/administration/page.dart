import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import 'package:get/get.dart';

import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/common/components/dav_app_bar.dart';


class AdministrationPage extends GetView<AdministrationController> {
  const AdministrationPage({Key? key}) : super(key: key);

 @override
  Widget build(BuildContext context) => Scaffold(
    appBar: kIsWeb ? const DavAppBar() : null,
    body: Center(
      child: Text('administration'.tr),
    ),
  );
}