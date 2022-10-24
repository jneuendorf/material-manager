import 'package:flutter/material.dart';

import 'package:get/get.dart';


class MultiSelectChip extends StatelessWidget {
  final List<String> options;
  final RxList<String> selectedOptions;

  const MultiSelectChip({
    super.key, 
    required this.options, 
    required this.selectedOptions,
  });

  @override
  Widget build(BuildContext context) => Wrap(
    children: options.map((option) => Obx(() => Padding(
      padding: const EdgeInsets.all(2.0),
      child: ChoiceChip(
        label: Text(option),
        selected: selectedOptions.contains(option),
        onSelected: (bool selected) {
          if (selectedOptions.contains(option)) {
            selectedOptions.remove(option);
          } else {
            selectedOptions.add(option);
          }
        },
        selectedColor: Get.theme.colorScheme.secondary,
      ),
    ))).toList(),
  );
}