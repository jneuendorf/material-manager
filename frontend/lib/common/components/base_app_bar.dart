import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/inventory/controller.dart';
import 'package:frontend/pages/inspection/controller.dart';
import 'package:frontend/pages/lender/controller.dart';
import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/pages/profile/controller.dart';
import 'package:frontend/pages/login/controller.dart';
import 'package:frontend/common/buttons/hover_text_button.dart';
import 'package:frontend/common/util.dart';


class BaseAppBar extends StatefulWidget with PreferredSizeWidget {
  final String? title;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool showBackButton;

  const BaseAppBar({
    Key? key,
    this.title,
    this.scaffoldKey,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  State<BaseAppBar> createState() => _BaseAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _BaseAppBarState extends State<BaseAppBar> {
  late final RxString currentRoute;
  late final bool loggedIn;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')) {
      currentRoute = '/'.obs;
    } else {
      currentRoute = '/${Get.currentRoute.split('/')[1]}'.obs;
    }

    loggedIn = Get.find<ApiService>().isAuthorized;
    debugPrint('loggedIn: $loggedIn');
  }

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: Get.theme.primaryColor,
    leading: buildLeading(),
    title: Text(widget.title ?? 'Material Verleih',
      style: const TextStyle(color: Colors.white),
    ),
    actions: [ 
      ...?isLargeScreen(context) ? [
        if (loggedIn) ...[
            Obx(() => Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: HoverTextButton(
              onTap: () => Get.toNamed(rentalRoute),
              text: 'rental'.tr,
              color: currentRoute.value == rentalRoute
                ? Get.theme.colorScheme.onSecondary
                : Colors.white,
              hoverColor: Get.theme.colorScheme.onSecondary.withOpacity(0.6),
              fontWeight: FontWeight.w600,
            ),
          )),
          Obx(() => Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: HoverTextButton(
              onTap: () => Get.toNamed(inventoryRoute),
              text: 'inventory'.tr,
              color: currentRoute.value == inventoryRoute
                ? Get.theme.colorScheme.onSecondary
                : Colors.white,
              hoverColor: Get.theme.colorScheme.onSecondary.withOpacity(0.6),
              fontWeight: FontWeight.w600,
            ),
          )),
          Obx(() => Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: HoverTextButton(
              onTap: () => Get.toNamed(inspectionRoute),
              text: 'inspection'.tr,
              color: currentRoute.value == inspectionRoute
                ? Get.theme.colorScheme.onSecondary
                : Colors.white,
              hoverColor: Get.theme.colorScheme.onSecondary.withOpacity(0.6),
              fontWeight: FontWeight.w600,
            ),
          )),
          Obx(() => Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: HoverTextButton(
              onTap: () => Get.toNamed(lenderRoute),
              text: 'lender'.tr,
              color: currentRoute.value == lenderRoute
                ? Get.theme.colorScheme.onSecondary
                : Colors.white,
              hoverColor: Get.theme.colorScheme.onSecondary.withOpacity(0.6),
              fontWeight: FontWeight.w600,
            ),
          )),
          Obx(() => Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: HoverTextButton(
              onTap: () => Get.toNamed(administrationRoute),
              text: 'administration'.tr,
              color: currentRoute.value == administrationRoute
                ? Get.theme.colorScheme.onSecondary
                : Colors.white,
              hoverColor: Get.theme.colorScheme.onSecondary.withOpacity(0.6),
              fontWeight: FontWeight.w600,
            ),
          )),
        ],
      ] : null,
      if ((!isLargeScreen(context) && !loggedIn) || 
        isLargeScreen(context)) Obx(() => IconButton(
        onPressed: () {
          if (loggedIn) {
            Get.toNamed(profileRoute);
          } else {
            Get.offAllNamed(loginRoute);
          }
        },
        icon: Icon(Icons.person,
          color: currentRoute.value == profileRoute
            ? Get.theme.colorScheme.onSecondary
            : Colors.white,
        ),
        splashRadius: 20.0,
      )),
    ],
  );

  Widget buildLeading() => Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: isLargeScreen(context)
      ? InkWell(
        onTap: () => Get.toNamed(rentalRoute),
        borderRadius: BorderRadius.circular(25.0),
        child: Image.asset('assets/images/logo_small.png'),
      )
      : loggedIn
        ? widget.showBackButton
          ? IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Get.back(),
          )
          : IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => widget.scaffoldKey?.currentState?.openDrawer(),
          )
        : null,
    );
}
