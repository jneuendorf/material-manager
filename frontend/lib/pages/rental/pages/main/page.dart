import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/rental/pages/main/screens/sets_screen.dart';
import 'package:frontend/pages/rental/pages/main/screens/single_material_screen.dart';


class MainRentalPage extends StatelessWidget {
  const MainRentalPage({super.key});

  static final rentalController = Get.find<RentalController>();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
        child: Row(
          children: [
            Expanded(
              child: TabBar(
                controller: rentalController.tabController,
                indicatorColor: Get.theme.primaryColor,
                tabs: [
                  Obx(() => Tab(
                    child: Text('single_material'.tr,
                      style: TextStyle(color: rentalController.tabIndex.value == 0
                          ?  Get.theme.primaryColor : null,
                      ),
                    ),
                  )),
                  Obx(() => Tab(
                    child: Text('sets'.tr,
                      style: TextStyle(color: rentalController.tabIndex.value == 1
                          ? Get.theme.primaryColor : null,
                      ),
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            buildCartButton(context),
          ],
        ),
      ),
      Expanded(
        child: TabBarView(
          controller: rentalController.tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            SingleMaterialScreen(),
            SetsScreen(),
          ],
        ),
      ),
    ],
  );

  Widget buildCartButton(context) => InkWell(
    onTap: () {
      //Navigator.of(context).pushNamed('/rentalShoppingCart');
      // Get.toNamed(homeRoute +'/rental'+ '/rentalShoppingCart', id: HomeController.homeNavigatorKey);
      //id: !kIsWeb ? HomeController.rentalNavigatorKey : null);
    },
    child: Container(
      width: 150,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Get.theme.colorScheme.surface,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Obx(() => Row(
        children: [
          const Icon(Icons.shopping_cart),
          const SizedBox(width: 4.0),
          Text('${rentalController.shoppingCart.length} ${'items'.tr}'),
          const Spacer(),
          Text('${rentalController.totalPrice} €'),
        ],
      )),
    ),
  );
}