import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/home/controller.dart';
import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/inventory/controller.dart';
import 'package:frontend/pages/inspection/controller.dart';
import 'package:frontend/pages/lender/controller.dart';
import 'package:frontend/pages/administration/controller.dart';


class DavAppBar extends StatelessWidget with PreferredSizeWidget{
  final bool loggedIn;

  const DavAppBar({
    Key? key, 
    this.loggedIn = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: Get.theme.primaryColor,
    title: const Text('Material Verleih'),
    actions: kIsWeb && loggedIn ? [
      TextButton(
        onPressed: () => Get.offNamed(homeRoute + rentalRoute), 
        child: Text('rental'.tr, 
          style: const TextStyle(color: Colors.white),
        ),
      ),
      TextButton(
        onPressed: () => Get.offNamed(homeRoute + inventoryRoute),
        child: Text('inventory'.tr, 
          style: const TextStyle(color: Colors.white),
        ),
      ),
      TextButton(
        onPressed: () => Get.offNamed(homeRoute + inspectionRoute),
        child: Text('inspection'.tr, 
        style: const TextStyle(color: Colors.white),
        ),
      ),
      TextButton(
        onPressed: () => Get.offNamed(homeRoute + lenderRoute),
        child: Text('lender'.tr, 
        style: const TextStyle(color: Colors.white),
        ),
      ),
      TextButton(
        onPressed: () => Get.offNamed(homeRoute + administrationRoute),
        child: Text('administration'.tr, 
        style: const TextStyle(color: Colors.white),
        ),
      ),
    ] : null,
  );

}