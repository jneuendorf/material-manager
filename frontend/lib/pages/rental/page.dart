import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/rental/pages/main/page.dart';
import 'package:frontend/pages/rental/pages/shoppingCart/page.dart';
import 'package:frontend/common/components/dav_app_bar.dart';
import 'package:frontend/common/components/dav_footer.dart';
import 'package:frontend/common/components/nested_navigator.dart';


class RentalPage extends GetView<RentalController> {
  const RentalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: kIsWeb ? const DavAppBar() : null,
    body: Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
      child: Column(
        children: [
          Expanded(
            child: NestedNavigator(
             // navigationKey: HomeController.navigationKey,
              tag: 'RentalPage',
                initialRoute: '/',
                routes: {
                  // default rout as '/' is necessary!
                  '/': (context) => const MainRentalPage(),
                  '/rental': (context) => const MainRentalPage(),
                  '/rentalShoppingCart': (context) => const ShoppingCartPage(),
                },
            ),
            // child: Navigator(
            //   key:  Get.nestedKey(HomeController.homeNavigatorKey),
            //   //!kIsWeb ? Get.nestedKey(HomeController.rentalNavigatorKey) : null,
            //   onGenerateRoute: (RouteSettings settings) {
            //     late final String pathSegment; 

            //     final String route = settings.name.toString();

            //     print('settings: ${settings.name.toString()}');
            //     
            
            //     final uri = Uri.parse(route);

            //     print('PLength: ${uri.pathSegments.length}');

            //     if(uri.pathSegments.length <= 2) {
            //       pathSegment = homeRoute + rentalRoute;
            //     } else {
            //       pathSegment = '/${uri.pathSegments[2]}';
            //     }
            //     print('RentalPathsegment: $pathSegment');
            //     switch (pathSegment) {
            //       case rentalShoppingCartRoute: return GetPageRoute(
            //         settings: settings,
            //         page: () => const ShoppingCartPage(),
            //       );
            //       default: return GetPageRoute(
            //         settings: settings,
            //         page: () => const MainRentalPage(),
            //       );
            //     }
            //   },
            // ),
          ),
          if (kIsWeb) const DavFooter(),
        ],
      ),
    ),
  );
}