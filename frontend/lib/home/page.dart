import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/home/controller.dart';
import 'package:frontend/pages/inventory/controller.dart';
import 'package:frontend/pages/inventory/page.dart';
import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/rental/page.dart';
import 'package:frontend/pages/inspection/controller.dart';
import 'package:frontend/pages/inspection/page.dart';
import 'package:frontend/pages/lender/controller.dart';
import 'package:frontend/pages/lender/page.dart';
import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/pages/administration/page.dart';
import 'package:frontend/common/components/dav_app_bar.dart';


class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: !kIsWeb ?  const DavAppBar() : null,
    drawer: !kIsWeb ? Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 100),
            ListTile(
              title: Text('rental'.tr),
              onTap: () {
                Get.back();
                Get.offNamed(homeRoute + rentalRoute, id: HomeController.navigatorKey);
              },
            ),
            ListTile(
              title: Text('inventroy'.tr),
              onTap: () {
                Get.back();
                Get.offNamed(homeRoute + inventoryRoute, id: HomeController.navigatorKey);
              },
            ),
            ListTile(
              title: Text('inspection'.tr),
              onTap: () {
                Get.back();
                Get.offNamed(homeRoute + inspectionRoute, id: HomeController.navigatorKey);
              },
            ),
            ListTile(
              title: Text('lender'.tr),
              onTap: () {
                Get.back();
                Get.offNamed(homeRoute + lenderRoute, id: HomeController.navigatorKey);
              },
            ),
            ListTile(
              title: Text('administration'.tr),
              onTap: () {
                Get.back();
                Get.offNamed(homeRoute + administrationRoute, id: HomeController.navigatorKey);
              },
            ),
          ],
        ),
      ),
    ) : null,
    body: Navigator(
      key: !kIsWeb ? Get.nestedKey(HomeController.navigatorKey) : null,
      onGenerateRoute: (RouteSettings settings) {
        late final String pathSegment; 

        final String route = !kIsWeb 
            ? settings.name.toString() 
            : ModalRoute.of(context)!.settings.name.toString();

        final uri = Uri.parse(route);
  
        if(uri.pathSegments.length <= 1) {
          pathSegment = homeRoute + rentalRoute;
        } else {
          pathSegment = '/${uri.pathSegments[1]}';
        }
    
        switch (pathSegment) {
          case rentalRoute: return GetPageRoute(
            settings: settings,
            page: () => const RentalPage(),
            binding: RentalBinding(),
          );
          case inventoryRoute: return GetPageRoute(
            settings: settings,
            page: () => const InventoryPage(),
            binding: InventoryBinding(),
          );
          case inspectionRoute: return GetPageRoute(
            settings: settings,
            page: () => const InspectionPage(),
            binding: InspectionBinding(),
          );
          case lenderRoute: return GetPageRoute(
            settings: settings,
            page: () => const LenderPage(),
            binding: LenderBinding(),
          );
          case administrationRoute: return GetPageRoute(
            settings: settings,
            page: () => const AdministrationPage(),
            binding: AdministrationBinding(),
          );
          default: return GetPageRoute(
            settings: settings,
            page: () => const RentalPage(),
            binding: RentalBinding(),
          );
        }
      },
    ),
  );
}