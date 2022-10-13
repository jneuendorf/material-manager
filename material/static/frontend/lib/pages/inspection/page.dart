import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import 'package:get/get.dart';

import 'package:frontend/pages/inspection/controller.dart';
import 'package:frontend/common/components/dav_app_bar.dart';


class InspectionPage extends GetView<InspectionController> {
  const InspectionPage({Key? key}) : super(key: key);

 @override
  Widget build(BuildContext context) => const Scaffold(
    appBar: kIsWeb ? DavAppBar() : null,
    body: Center(
      child: Text('Inspection'),
    ),
  );
}