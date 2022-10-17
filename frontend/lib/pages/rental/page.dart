import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/common/components/dav_app_bar.dart';
import 'package:frontend/common/components/dav_footer.dart';


class RentalPage extends GetView<RentalController> {
  const RentalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: kIsWeb ? const DavAppBar() : null,
    body: Column(
      children: [
        Expanded(
          child: Center(
            child: Text('rental'.tr),
          ),
        ),
        if (kIsWeb) const DavFooter(),
      ],
    ),
  );
}