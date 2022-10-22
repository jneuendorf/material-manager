import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/inventory/controller.dart';
import 'package:frontend/pages/inspection/controller.dart';
import 'package:frontend/pages/lender/controller.dart';
import 'package:frontend/pages/administration/controller.dart';


class DavAppBar extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  final bool loggedIn;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool showBackButton;

  const DavAppBar({
    Key? key, 
    this.title,
    this.loggedIn = true,
    this.scaffoldKey,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: Get.theme.primaryColor,
    leading: buildLeading(),
    title: Text(title ?? 'Material Verleih', 
      style: const TextStyle(color: Colors.white),
    ),
    actions: kIsWeb && loggedIn ? [
      TextButton(
        onPressed: () {
          Get.toNamed(rentalRoute);
        },
        child: Text('rental'.tr, 
          style: const TextStyle(color: Colors.white),
        ),
      ),
      TextButton(
        onPressed: () {
          Get.toNamed(inventoryRoute);
        },
        child: Text('inventory'.tr, 
          style: const TextStyle(color: Colors.white),
        ),
      ),
      TextButton(
        onPressed: () => Get.toNamed(inspectionRoute),
        child: Text('inspection'.tr, 
        style: const TextStyle(color: Colors.white),
        ),
      ),
      TextButton(
        onPressed: () => Get.toNamed(lenderRoute),
        child: Text('lender'.tr, 
        style: const TextStyle(color: Colors.white),
        ),
      ),
      TextButton(
        onPressed: () => Get.toNamed(administrationRoute),
        child: Text('administration'.tr, 
        style: const TextStyle(color: Colors.white),
        ),
      ),
    ] : null,
  );

  Widget buildLeading() => Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: kIsWeb 
      ? Image.asset('assets/images/dav_logo_small.png') 
      : loggedIn 
        ? showBackButton 
          ? IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          )
          : IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => scaffoldKey?.currentState?.openDrawer(),
          ) 
        : null,
    );

}