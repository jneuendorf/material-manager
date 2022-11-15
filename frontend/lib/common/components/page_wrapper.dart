import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/util.dart';

import 'package:get/get.dart';

import 'package:frontend/common/components/base_app_bar.dart';
import 'package:frontend/common/components/base_footer.dart';
import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/pages/inspection/controller.dart';
import 'package:frontend/pages/inventory/controller.dart';
import 'package:frontend/pages/lender/controller.dart';
import 'package:frontend/pages/profile/controller.dart';


class PageWrapper extends StatelessWidget {
  final Widget child;
  final String? pageTitle;
  final bool showBackButton;
  final bool showFooter;
  final bool showPadding;

  PageWrapper({
    super.key,
    required this.child,
    this.pageTitle,
    this.showBackButton = false,
    this.showFooter = true,
    this.showPadding = true,
  });

  final  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => Scaffold(
    key: scaffoldKey,
    appBar: BaseAppBar(
      title: pageTitle,
      scaffoldKey: scaffoldKey,
      showBackButton: showBackButton,
    ),
    drawer: isLargeScreen(context) ? null : buildDrawer(),
    body: SafeArea(
      child: Padding(
        padding: showPadding
          ? const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0)
          : EdgeInsets.zero,
        child: Column(
          children: [
            Expanded(
              child: child,
            ),
            if (kIsWeb && showFooter) showPadding
              ? const BaseFooter()
              : const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: BaseFooter(),
              ),
          ],
        ),
      ),
    ),
  );

  Drawer buildDrawer() {
    RxString currentRoute = '/'.obs;

    if (!kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST')) {
      currentRoute = '/${Get.currentRoute.split('/')[1]}'.obs;
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: InkWell(
              onTap: () => Get.toNamed(profileRoute),
              borderRadius: BorderRadius.circular(25.0),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 25.0,
                  child: Icon(Icons.person, size: 55),
                ),
              ),
              ),
          ),
          Obx(() => ListTile(
            title: Text('rental'.tr),
            leading: const Icon(Icons.shopping_cart),
            textColor: currentRoute.value == rentalRoute
              ? Get.theme.colorScheme.onSecondary
              : null,
            onTap: () => Get.offNamed(rentalRoute),
          )),
          Obx(() => ListTile(
            title: Text('inventory'.tr),
            leading: const Icon(Icons.inventory),
            textColor: currentRoute.value == inventoryRoute
              ? Get.theme.colorScheme.onSecondary
              : null,
            onTap: () => Get.offNamed(inventoryRoute),
          )),
          Obx(() => ListTile(
            title: Text('inspection'.tr),
            leading: const Icon(Icons.search_off),
            textColor: currentRoute.value == inspectionRoute
              ? Get.theme.colorScheme.onSecondary
              : null,
            onTap: () => Get.offNamed(inspectionRoute),
          )),
          Obx(() => ListTile(
            title: Text('lender'.tr),
            leading: const Icon(Icons.calendar_month),
            textColor: currentRoute.value == lenderRoute
              ? Get.theme.colorScheme.onSecondary
              : null,
            onTap: () => Get.offNamed(lenderRoute),
          )),
          Obx(() => ListTile(
            title: Text('administration'.tr),
            leading: const Icon(Icons.manage_accounts),
            textColor: currentRoute.value == administrationRoute
              ? Get.theme.colorScheme.onSecondary
              : null,
            onTap: () => Get.offNamed(administrationRoute),
          )),
        ],
      ),
    );
  }
}
