import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/rental/screens/sets_screen.dart';
import 'package:frontend/pages/rental/screens/single_material_screen.dart';
import 'package:frontend/pages/rental/components/period_selector.dart';
import 'package:frontend/common/components/page_wrapper.dart';


class RentalPage extends GetView<RentalPageController> {
  const RentalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PageWrapper(
    pageTitle: 'rental'.tr,
    showFooter: false,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: PeriodSelector(small: true),
                ),
              ),
              buildCartButton(context),
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
      ],
    ),
  );

  Widget buildCartButton(context) => InkWell(
    onTap: () {
      if (controller.rentalPeriod.value != null){
        Get.toNamed(rentalShoppingCartRoute);
      } else {
        Get.snackbar('error'.tr, 'missing_rental_period'.tr);
      }
    },
    borderRadius: BorderRadius.circular(5.0),
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
          Expanded(child: Text('${controller.shoppingCart.length} ${'items'.tr}',
            maxLines: 1,
          )),
          Text('${controller.totalPrice.toStringAsFixed(2)} €'),
        ],
      )),
    ),
  );
}
