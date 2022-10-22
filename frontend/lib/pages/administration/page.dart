import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/pages/administration/screens/account_screen.dart';
import 'package:frontend/pages/administration/screens/role_screen.dart';


class AdministrationPage extends GetView<AdministrationPageController> {
  const AdministrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PageWrapper(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: controller.tabbBarController,
                    indicatorColor: Get.theme.primaryColor,
                    tabs: [
                      Obx(() => Tab(
                        child: Text(
                          'accounts'.tr,
                          style: TextStyle(
                            color: controller.tabBarIndex.value == 0
                                ? Get.theme.primaryColor
                                : null,
                          ),
                        ),
                      )),
                      Obx(() => Tab(
                        child: Text(
                          'roles'.tr,
                          style: TextStyle(
                            color: controller.tabBarIndex.value == 1
                                ? Get.theme.primaryColor
                                : null,
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabbBarController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                AccountScreen(),
                RoleScreen(),
              ],
            ),
          ),
        ],
      ),
    );
}
