import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import 'package:get/get.dart';

import 'package:frontend/pages/lender/controller.dart';
import 'package:frontend/common/components/dav_app_bar.dart';


class LenderPage extends GetView<LenderController> {
  const LenderPage({Key? key}) : super(key: key);

 @override
  Widget build(BuildContext context) => const Scaffold(
    appBar: kIsWeb ? DavAppBar() : null,
    body: Center(
      child: Text('Lender'),
    ),
  );
}