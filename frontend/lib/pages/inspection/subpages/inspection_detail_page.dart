import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/inspection/controller.dart';
import 'package:frontend/common/buttons/drop_down_filter_button.dart';
import 'package:frontend/common/components/page_wrapper.dart';


class InspectionDetailPage extends StatelessWidget {
  const InspectionDetailPage({super.key});

  static final inspectionPageController = Get.find<InspectionPageController>();

  @override
  Widget build(BuildContext context) => PageWrapper(
    showBackButton: !kIsWeb,
    pageTitle: 'inspection_details'.tr,
    child: Row(
      children: [
        Column(
          children:  [
            Obx(() => DropDownFilterButton(
              options: [
                'all'.tr,
                ...inspectionPageController.typeFilterOptions.values,
              ],
              selected: inspectionPageController.selectedInspectionType.value?.name ?? 'all'.tr,
              onSelected: (String value) {}
            )),
            Expanded(
              child: Obx(() {
                if (inspectionPageController.selectedMaterial.value?.imagePath != null) {
                  return SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: !(!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST'))
                      ? Image.network(inspectionPageController.selectedMaterial.value!.imagePath!)
                      : null,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Obx(() => ListView.separated(
                  separatorBuilder:  (BuildContext context, int index) => const Divider(),
                  itemCount: inspectionPageController.inspectionController.inspections.length,
                  itemBuilder: (context, index) => ConstrainedBox(
                    constraints: const BoxConstraints(),
                    child: Card(
                      child: Column(
                        children: [
                          Row(),
                          Row(),
                        ],
                      ),
                    ),
                  ),
                )),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
