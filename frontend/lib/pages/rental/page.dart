import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/rental/screens/single_material_screen.dart';
import 'package:frontend/pages/rental/screens/sets_screen.dart';
import 'package:frontend/common/components/dav_app_bar.dart';
import 'package:frontend/common/components/dav_footer.dart';


class RentalPage extends GetView<RentalController> {
  const RentalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: kIsWeb ? const DavAppBar() : null,
    body: Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: controller.tabController,
                    indicatorColor: Get.theme.primaryColor,
                    tabs: [
                      Obx(() => Tab(
                        child: Text('single_material'.tr,
                          style: TextStyle(color: controller.tabIndex.value == 0
                              ?  Get.theme.primaryColor : null,
                          ),
                        ),
                      )),
                      Obx(() => Tab(
                        child: Text('sets'.tr,
                          style: TextStyle(color: controller.tabIndex.value == 1
                              ? Get.theme.primaryColor : null,
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                buildCartButton(),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                SingleMaterialScreen(),
                SetsScreen(),
              ],
            ),
          ),
          if (kIsWeb) const DavFooter(),
        ],
      ),
    ),
  );

  Widget buildCartButton() => InkWell(
    onTap: () {},
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
          Text('${controller.shoppingCart.length} ${'items'.tr}'),
          const Spacer(),
          Text('${controller.totalPrice} €'),
        ],
      )),
    ),
  );
}