import 'package:flutter/material.dart';

import 'package:get/get.dart';


class NoPermissionWidget extends StatelessWidget {
  const NoPermissionWidget({super.key});

  @override
  Widget build(BuildContext context) => Material(
    child: Center(
      child: Text('no_permission'.tr),
    ),
  );
}