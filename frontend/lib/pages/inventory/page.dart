import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/pages/inventory/controller.dart';
import 'package:frontend/pages/inventory/dialogs/add_item_dialog.dart';
import 'package:frontend/pages/inventory/dialogs/product_details_dialog.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/components/base_footer.dart';
import 'package:frontend/common/components/collapsable_expansion_tile.dart';
import 'package:frontend/common/buttons/drop_down_filter_button.dart';
import 'package:frontend/common/buttons/text_icon_button.dart';


class InventoryPage extends GetView<InventoryPageController> {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PageWrapper(
    pageTitle: 'inventory'.tr,
    showFooter: false,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => DropDownFilterButton(
                title: 'type'.tr,
                options: [
                  'all'.tr,
                  ...controller.typeFilterOptions.values,
                ],
                selected: controller.selectedTypeFilter.value?.name ?? 'all'.tr,
                onSelected: controller.onTypeFilterSelected,
              )),
              const SizedBox(width: 8.0),
              Obx(() => DropDownFilterButton(
                title: 'condition'.tr,
                options: [
                  'all'.tr,
                  ConditionModel.good.toString().split('.').last.tr,
                  ConditionModel.broken.toString().split('.').last.tr,
                ],
                selected: controller.selectedConditionFilter.value?.toString().split('.').last ?? 'all'.tr,
                onSelected: controller.onConditionFilterSelected,
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
              TextIconButton(
                onTap: () => Get.dialog(AddItemDialog()),
                iconData: Icons.add,
                text: 'add_item'.tr,
                color: Get.theme.colorScheme.onSecondary,
              ),
            ],
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Obx(() => Checkbox(
                value: controller.selectAll.value,
                onChanged: (bool? value) => controller.selectAll.value = value!,
              )),
            ),
            const SizedBox(width: 70),
            Expanded(child: Text('type'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
            Expanded(child: Text('condition'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
            Expanded(child: Text('next_inspection'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
            const SizedBox(width: 50.0),
          ],
        ),
        const Divider(),
        Expanded(
          child: Obx(() {
            final List<GlobalKey<CollapsableExpansionTileState>> keys = List.generate(
              controller.filteredMaterial.length, (index) => GlobalKey<CollapsableExpansionTileState>(),
            );
            return ListView.separated(
            itemCount: controller.filteredMaterial.length,
            separatorBuilder: (BuildContext context, int index) => const Divider(),
            itemBuilder: (BuildContext context, int index) {
              final RxBool selected = false.obs;
              controller.selectAll.listen((bool value) {
                selected.value = value;
              });
              return CollapsableExpansionTile(
                key: keys[index],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    List<GlobalKey<CollapsableExpansionTileState>> otherKeys = keys.where(
                      (key) => key != keys[index]
                    ).toList();

                    for (var key in otherKeys) {
                      if (key.currentState!.tileIsExpanded.value) {
                        key.currentState!.collapse();
                      }
                    }
                  }
                },
                title: Row(
                  children: [
                    Obx(() => Checkbox(
                      value: selected.value,
                      onChanged: (bool? value) => selected.value = value!,
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: 50,
                        child: !kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST') 
                          ? Image.network(controller.filteredMaterial[index].imagePath!) 
                          : null,
                      ),
                    ),
                    Expanded(child: Text(controller.filteredMaterial[index].materialType.name)),
                    Expanded(child: Text(controller.filteredMaterial[index].condition.toString().split('.').last.tr)),
                    Expanded(child: Text(controller.formatDate(controller.filteredMaterial[index].nextInspectionDate))),
                  ],
                ),
                children: [
                  buildExpansionCard(controller.filteredMaterial[index]),
                ],
              );
            },
          );
          }),
        ),
        if (kIsWeb)const BaseFooter(),
      ],
    ),
  );

  Widget buildExpansionCard(MaterialModel item) => Card(
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: SizedBox(
      height: 200.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: !kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST') 
                        ? DecorationImage(
                          image: NetworkImage(item.imagePath!),
                        ) 
                        : null,
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 15),
                      const Text('1 von 4'), // TODO add image count
                      IconButton(
                        padding: EdgeInsets.zero,
                        splashRadius: 18.0,
                        icon: const Icon(Icons.arrow_right),
                        onPressed: () {},
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildCustomTextField(
                    item.materialType.name,
                    'type'.tr,
                  ),
                  buildCustomTextField(
                    controller.formatDate(item.installationDate),
                    'installation'.tr,
                  ),
                  buildCustomTextField(
                    item.usage.toString(),
                    'usage_in_days'.tr,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildCustomTextField(
                    controller.formatDate(item.nextInspectionDate),
                    'next_inspection'.tr,
                  ),
                  buildCustomTextField(
                    '€ ${item.rentalFee.toString()}',
                    'rental_fee'.tr,
                  ),
                  const SizedBox(height: 12.0),
                  TextIconButton(
                    onTap: () => Get.dialog(ProductDetailsDialog(item: item)),
                    iconData: Icons.arrow_drop_down,
                    text: 'product_details'.tr,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  TextFormField buildCustomTextField(String text, String label) => TextFormField(
    readOnly: true,
    initialValue: text,
    decoration: InputDecoration(
      labelText: label,
    ),
  );
}
