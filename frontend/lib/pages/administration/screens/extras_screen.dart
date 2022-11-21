import 'package:flutter/material.dart';

import 'package:get/get.dart';


class ExtrasScreen extends StatelessWidget {
  const ExtrasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = buildChildren();

    return ListView.separated(
      itemCount: children.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) => children[index],
    );
  }

  List<Widget> buildChildren() => [
    ListTile(
      onTap: () {}, // needed for hover effect
      hoverColor: Get.theme.colorScheme.primary.withOpacity(0.12),
      title: Text('export_inventory_to_csv'.tr),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Get.theme.colorScheme.onSecondary),
        onPressed: () {},
        child: Text('export'.tr,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),    
    ),
  ];
}