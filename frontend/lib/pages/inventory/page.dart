import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/pages/inventory/controller.dart';
import 'package:frontend/pages/inventory/dialogs/add_item_dialog.dart';
import 'package:frontend/pages/inventory/dialogs/product_details_dialog.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/components/base_footer.dart';
import 'package:frontend/common/components/collapsable_expansion_tile.dart';
import 'package:frontend/common/buttons/drop_down_filter_button.dart';
import 'package:frontend/common/buttons/text_icon_button.dart';
import 'package:frontend/common/util.dart';


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
                  ...ConditionModel.values.map((e) => e.name.tr).toList(),
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
                onTap: () => Get.dialog(const AddItemDialog()),
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
                      if (key.currentState != null && key.currentState!.tileIsExpanded.value) {
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
                        child: !isTest()
                          ? controller.filteredMaterial[index].imageUrls.isNotEmpty
                            ? Image.network(baseUrl + controller.filteredMaterial[index].imageUrls.first)
                            : const Icon(Icons.image)
                          : null,
                      ),
                    ),
                    Expanded(child: Text(controller.filteredMaterial[index].materialType.name)),
                    Expanded(child: Text(controller.filteredMaterial[index].condition.toString().split('.').last.tr)),
                    Expanded(child: Text(formatDate(controller.filteredMaterial[index].nextInspectionDate))),
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
        if (kIsWeb) const BaseFooter(),
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
            buildImagePreview(item.imageUrls),
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
                    formatDate(item.installationDate),
                    'installation'.tr,
                  ),
                  buildCustomTextField(
                    item.daysUsed.toString(),
                    'days_used'.tr,
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
                    formatDate(item.nextInspectionDate),
                    'next_inspection'.tr,
                  ),
                  buildCustomTextField(
                    '€ ${item.rentalFee.toString()}',
                    'rental_fee'.tr,
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextIconButton(
                        onTap: () => Get.dialog(ProductDetailsDialog(item: item)),
                        iconData: Icons.arrow_drop_down,
                        text: 'product_details'.tr,
                      ),
                      TextIconButton(
                      onTap: () => Get.dialog(AddItemDialog(initialMaterial: item)),
                      iconData: Icons.edit,
                      text: 'edit_item'.tr,
                      color: Get.theme.colorScheme.onSecondary,
                    ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget buildImagePreview(List<String> imageUrls) {
    final RxInt imageIndex = 0.obs;

    return SizedBox(
      width: 100,
      child: imageUrls.isNotEmpty ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Obx(() => Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: !isTest() ? DecorationImage(
                image: NetworkImage(baseUrl + imageUrls[imageIndex.value]),
              ) : null,
            ),
            child: imageUrls.isEmpty
              ? const Icon(Icons.image)
              : Container(),
          )),
          Row(
            children: [
              const SizedBox(width: 15),
              Text('1 von ${imageUrls.length}'),
              IconButton(
                padding: EdgeInsets.zero,
                splashRadius: 18.0,
                icon: const Icon(Icons.arrow_right),
                onPressed: () {
                  if (imageIndex.value < imageUrls.length - 1) {
                    imageIndex.value++;
                  }
                },
              )
            ],
          ),
        ],
      ) : const Icon(Icons.image),
    );
  }

  TextFormField buildCustomTextField(String text, String label) => TextFormField(
    readOnly: true,
    initialValue: text,
    decoration: InputDecoration(
      labelText: label,
    ),
  );
}
