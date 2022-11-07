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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:  [
              Text(inspectionPageController.selectedMaterial.value!.materialType.name),
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
                        ? Image.network(inspectionPageController.selectedMaterial.value!.imagePath!)
                        : null,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Obx(() => ListView.separated(
            separatorBuilder:  (BuildContext context, int index) => const Divider(),
            itemCount: inspectionPageController.inspectionController.inspections.length,
            itemBuilder: (context, index) => ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400,
                maxHeight: 400,
              ),
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('${'inspection'.tr} : ',
                                    style:  const TextStyle(color: Colors.black45,fontSize: 16),
                                  ),
                                  Text(inspectionPageController.inspectionController.inspections[index].type.name,
                                    style:  const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('${'inspection_date'.tr} : ',
                                    style:  const TextStyle(color: Colors.black45,fontSize: 16),
                                  ),
                                  Text(inspectionPageController.getInspectionDate(index),
                                    style:  const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('${'inspector'.tr} : ',
                                    style:  const TextStyle(color: Colors.black45,fontSize: 16),
                                  ),
                                  Text(inspectionPageController.getInspectorName(index),
                                      style:  const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Container(
                            child: !(!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST'))
                                ? Image.network(inspectionPageController.inspectionController.inspections[index].comment.imagePath!)
                                : null,
                          )
                        ],
                      ),
                      TextFormField(
                        minLines: 4,
                        maxLines: 4,
                        initialValue: inspectionPageController.inspectionController.inspections[index].comment.text ,
                        decoration: InputDecoration(
                          labelText: 'comment'.tr,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
        ),
      ],
    ),
  );
}
