import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/rental/components/template_widget.dart';
import 'package:frontend/common/buttons/drop_down_filter_button.dart';


class SingleMaterialScreen extends StatelessWidget {
  const SingleMaterialScreen({super.key});

  static final rentalPageController = Get.find<RentalPageController>();

  @override
  Widget build(BuildContext context) => TemplateWidget(
    materialList: rentalPageController.filteredMaterial,
    headerWidget: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => DropDownFilterButton(
          title: 'type'.tr,
          options: [
            'all'.tr,
            ...rentalPageController.filterOptions.values,
          ],
          selected: rentalPageController.selectedFilter.value?.name ?? 'all'.tr,
          onSelected: rentalPageController.onFilterSelected,
        )),
        const SizedBox(width: 16.0),
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 200.0,
              maxWidth: 300.0
            ),
            child: CupertinoSearchTextField(
              placeholder: 'search'.tr,
              onChanged: (String text) {
                rentalPageController.searchTerm.value = text;
                rentalPageController.runFilter();
              },
            ),
          ),
        ),
        const SizedBox(width: 16.0),
      ],
    ),
  );
}
