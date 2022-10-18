import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/rental/components/template_widget.dart';
import 'package:frontend/common/buttons/drop_down_filter_button.dart';


class SingleMaterialScreen extends StatelessWidget {
  const SingleMaterialScreen({super.key});

  static final rentalController = Get.find<RentalController>();

  @override
  Widget build(BuildContext context) => TemplateWidget(
    materialList: rentalController.filteredMaterial,
    headerWidget: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => DropDownFilterButton(
          title: 'type'.tr, 
          options: [
            'all'.tr, 
            ...rentalController.filterOptions.values,
          ],
          selected: rentalController.selectedFilter.value?.description ?? 'all'.tr, 
          onSelected: rentalController.onFilterSelected,
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
                rentalController.searchTerm.value = text;
                rentalController.runFilter();
              },
            ),
          ),
        ),
        const SizedBox(width: 16.0),
      ],
    ),
  );
}