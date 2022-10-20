import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';


class AdministrationPage extends GetView<AdministrationPageController> {
  const AdministrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PageWrapper(
    child: Center(
      child: Text('administration'.tr),
    ),
  );
}