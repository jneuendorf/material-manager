import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/pages/administration/screens/account_screen.dart';
import 'package:frontend/pages/administration/screens/role_screen.dart';
import 'package:frontend/pages/administration/screens/extras_screen.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/components/no_permission_widget.dart';


class AdministrationPage extends GetView<AdministrationPageController> {
  const AdministrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => controller.apiService.isSuperUser ? PageWrapper(
    pageTitle: 'administration'.tr,
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
                      child: Text('accounts'.tr,
                        style: TextStyle(
                          color: controller.tabIndex.value == 0
                              ? Get.theme.primaryColor
                              : null,
                        ),
                      ),
                    )),
                    Obx(() => Tab(
                      child: Text('roles'.tr,
                        style: TextStyle(
                          color: controller.tabIndex.value == 1
                              ? Get.theme.primaryColor
                              : null,
                        ),
                      ),
                    )),
                    Obx(() => Tab(
                      child: Text('extras'.tr,
                        style: TextStyle(
                          color: controller.tabIndex.value == 2
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
            controller: controller.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              AccountScreen(),
              RoleScreen(),
              ExtrasScreen(),
            ],
          ),
        ),
      ],
    ),
  ) : const NoPermissionWidget();
}
