import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/lender/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';


class LenderPage extends GetView<LenderController> {
  const LenderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PageWrapper(
    child: Center(
      child: Text('lender'.tr),
    ),
  );
}