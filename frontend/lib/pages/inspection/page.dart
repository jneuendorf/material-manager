import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/inspection/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/buttons/drop_down_filter_button.dart';


class InspectionPage extends GetView<InspectionPageController> {
  const InspectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PageWrapper(
    pageTitle: 'inspection'.tr,
    child: Row(
      children: [
        Column(
          children:  [
            Obx(() => DropDownFilterButton(
              options: controller.availableInspectionTypes,
              selected: controller.selectedInspectionType.value?.name ?? 'all'.tr,
              onSelected: (String value ) {
                // TODO: update InspectionType of InspectionModel.type
              },
            )),
            Expanded(
              child: Obx(() {
                if (controller.currentMaterial.value?.imagePath != null) {
                  return SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: !kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST') 
                      ? Image.network(controller.currentMaterial.value!.imagePath!)
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
                  itemCount: controller.inspectionController.inspections.length,
                  itemBuilder: (context, index) => ConstrainedBox(
                    constraints: const BoxConstraints(),
                    child: const Card(),
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
