import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/util.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/inspection/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/buttons/text_icon_button.dart';


class InspectionDetailPage extends StatelessWidget {
  const InspectionDetailPage({super.key});

  static final inspectionPageController = Get.find<InspectionPageController>();

  @override
  Widget build(BuildContext context) => PageWrapper(
    showBackButton: !isLargeScreen(context),
    pageTitle: 'inspection_details'.tr,
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children:  [
                  Row(
                    children: [
                      Text('${'type'.tr} : ',
                        style:  const TextStyle(color: Colors.black45,fontSize: 16),
                      ),
                      if (inspectionPageController.selectedMaterials.isNotEmpty) Text(
                        inspectionPageController.selectedMaterials.first.materialType.name,
                          style: const TextStyle(fontSize: 16)
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  if (inspectionPageController.selectedMaterials.isNotEmpty) Obx(() {
                    if (inspectionPageController.selectedMaterials.first.imageUrls.isNotEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: !(!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST'))
                            ? Image.network(inspectionPageController.selectedMaterials.first.imageUrls.first)
                            : null,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                  const SizedBox(height: 16.0),
                  TextIconButton(
                    onTap: () {},
                    iconData: Icons.add,
                    text: 'add_inspection'.tr,
                    color: Get.theme.colorScheme.onSecondary,
                  ),
                ],
              ),
            ),
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
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            Expanded(
                              child: !(!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST'))
                                  ? Image.network(inspectionPageController.inspectionController.inspections[index].comment.imagePath!)
                                  : Container(),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        enabled: false,
                        minLines: 4,
                        maxLines: 4,
                        initialValue: inspectionPageController.inspectionController.inspections[index].comment.text ,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
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
