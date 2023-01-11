import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/pages/inspection/controller.dart';
import 'package:frontend/extensions/inspection/model.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/buttons/text_icon_button.dart';
import 'package:frontend/common/util.dart';


class InspectionDetailPage extends StatefulWidget {
  const InspectionDetailPage({super.key});

  @override
  State<InspectionDetailPage> createState() => _InspectionDetailPageState();
}

class _InspectionDetailPageState extends State<InspectionDetailPage> {
  final inspectionPageController = Get.find<InspectionPageController>();

  final RxList<Comment> comments = <Comment>[].obs;
  final Rxn<InspectionModel> selectedInspection = Rxn<InspectionModel>();

  Future<void> asyncInit() async {
    if (inspectionPageController.selectedMaterial.value?.id == null) {
      debugPrint('No material selected!');
      return;
    }

    comments.value = (await inspectionPageController.inspectionController.getAllComments(inspectionPageController.selectedMaterial.value!.id!)) ?? [];
    
    if (comments.isEmpty) return; 
    
    selectedInspection.value = await inspectionPageController.inspectionController.getInspection(comments.first.inspectionId);
  }

  @override
  void initState() {
    super.initState();

    asyncInit();
  }

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
                      if (inspectionPageController.selectedMaterial.value != null) Text(
                        inspectionPageController.selectedMaterial.value!.materialType.name,
                          style: const TextStyle(fontSize: 16)
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  if (inspectionPageController.selectedMaterial.value != null) Obx(() {
                    if (inspectionPageController.selectedMaterial.value!.imageUrls.isNotEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: !isTest()
                            ? inspectionPageController.selectedMaterial.value!.imageUrls.isNotEmpty 
                              ? Image.network(baseUrl + inspectionPageController.selectedMaterial.value!.imageUrls.first)
                              : const Icon(Icons.image)
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
          child: Obx(() => comments.isEmpty || selectedInspection.value == null ? Center(
            child: Text('no_comments'.tr),
          ) : ListView.separated(
            separatorBuilder: (BuildContext context, int index) => const Divider(),
            itemCount: comments.length,
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
                                      style:  const TextStyle(color: Colors.black45, fontSize: 16),
                                    ),
                                    const Text('Inspection', // TODO  inspection type
                                      style:  TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('${'inspection_date'.tr} : ',
                                      style:  const TextStyle(color: Colors.black45,fontSize: 16),
                                    ),
                                    Text(formatDate(selectedInspection.value!.date),
                                      style:  const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('${'inspector'.tr} : ',
                                      style:  const TextStyle(color: Colors.black45, fontSize: 16),
                                    ),
                                    Text(inspectionPageController.getInspectorName(selectedInspection.value!.inspectorId),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: !isTest() && comments[index].imagePath != null
                                  ? Image.network(comments[index].imagePath!)
                                  : Container(),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        enabled: false,
                        minLines: 4,
                        maxLines: 4,
                        initialValue: comments[index].text,
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
