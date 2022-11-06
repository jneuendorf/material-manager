import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/extensions/material/model.dart';

import 'package:get/get.dart';

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
        Expanded(
          child: Obx(() => ListView.separated(
            itemCount: controller.filteredMaterial.length,
            separatorBuilder:  (BuildContext context, int index) => const Divider(),
            itemBuilder: (BuildContext context, int index) {
              final MaterialModel material = controller.filteredMaterial[index];

              return ListTile(
                onTap: () => controller.onMaterialSelected(material),
                title: Text(material.materialType.name),
                subtitle: Text(material.inventoryNumber),
                leading: SizedBox(
                  width: 50,
                  child: !(!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST'))
                    ? Image.network(material.imagePath!)
                    : null,
                ),
                //trailing: Text(material.type.name), // TODO add inspection type
              );
            },
          )),
        ),
      ],
    ),
  );
}
