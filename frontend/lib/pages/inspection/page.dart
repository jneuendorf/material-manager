import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/extensions/material/model.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:frontend/pages/inspection/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/buttons/drop_down_filter_button.dart';


class InspectionPage extends GetView<InspectionPageController> {
  const InspectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PageWrapper(
    pageTitle: 'inspection'.tr,
    child: Column(
      children:  [
        Row(
          children: [
            Obx(() => DropDownFilterButton(
              options: [
                'all'.tr,
                ...controller.typeFilterOptions.values,
              ],
              selected: controller.selectedInspectionType.value?.name ?? 'all'.tr,
              onSelected: controller.onTypeFilterSelected,
            )),
            const SizedBox(width: 8.0),
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 200.0,
                  maxWidth: 300.0
                ),
                child: CupertinoSearchTextField(
                  placeholder: 'search'.tr,
                  onChanged: (String text) {
                    controller.searchTerm.value = text;
                    controller.runFilter();
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Obx(() => Checkbox(
            value: controller.selectAll.value,
            onChanged: (bool? value) => controller.selectAll.value = value!,
            )),
            ),
          ],
        ),
        const Divider(color: Colors.grey),

        Expanded(
          child: Obx(() => ListView.separated(
            itemCount: controller.filteredMaterial.length,
            separatorBuilder:  (BuildContext context, int index) => const Divider(),
            itemBuilder: (BuildContext context, int index) {
              final MaterialModel material = controller.filteredMaterial[index];
              final RxBool selected = false.obs;
              controller.selectAll.listen((bool value) {
                selected.value = value;
              });

              return ListTile(
                onTap: () => controller.onMaterialSelected(material),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 50,
                      child: !(!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST'))
                          ? Image.network(material.imagePath!)
                          : null,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(material.materialType.name),
                        Text(material.inventoryNumber, style: const TextStyle(color: Colors.grey),),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${'next_inspection'.tr} :', style: const TextStyle(color: Colors.grey),),
                        Text(DateFormat('dd.MM.yyyy').format(material.nextInspectionDate))
                      ],
                    ),
                  ],
                ),
                leading: Obx(() => Checkbox(
                  value: selected.value,
                  onChanged: (bool? value) {
                    selected.value = value!;
                    if (value) {
                      controller.selectedMaterials.remove(material);
                    } else {
                      controller.selectedMaterials.add(material);
                    }
                  } ,
                )),
                //trailing: Text(material.type.name), // TODO add inspection type
              );
            },
          )),
        ),
      ],
    ),
  );
}
