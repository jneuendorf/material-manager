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
        Expanded(
          flex: 2,
          child: Column(
            children:  [
              Obx(() => DropDownFilterButton(
                options: [
                  'all'.tr,
                  ...inspectionPageController.typeFilterOptions.values,
                ],
                selected: inspectionPageController.selectedInspectionType.value?.name ?? 'all'.tr,
                onSelected: (String value) {}
              )),
              Obx(() {
                if (inspectionPageController.selectedMaterial.value?.imagePath != null) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: !(!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST'))
                        ? Expanded(child: Image.network(inspectionPageController.selectedMaterial.value!.imagePath!))
                        : null,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
        const Divider(color: Colors.grey),
        Expanded(
          flex: 4,
          child: Obx(() => ListView.separated(
            separatorBuilder:  (BuildContext context, int index) => const Divider(),
            itemCount: inspectionPageController.inspectionController.inspections.length,
            itemBuilder: (context, index) => ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 370,
                maxHeight: 370,
              ),
              child: Card(
                elevation: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(inspectionPageController.inspectionController.inspections[index].type.name),
                          Container(
                            child: !(!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST'))
                                ? Image.network(inspectionPageController.inspectionController.inspections[index].comment.imagePath!)
                                : null,
                          )
                        ],
                      ),
                    ),
                    TextFormField(
                      minLines: 4,
                      maxLines: 6,
                      initialValue: inspectionPageController.inspectionController.inspections[index].comment.text ,
                      decoration: InputDecoration(
                        labelText: 'comment'.tr,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
        ),
      ],
    ),
  );
}
