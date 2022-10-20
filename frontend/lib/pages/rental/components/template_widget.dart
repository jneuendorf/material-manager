import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/pages/rental/components/material_preview.dart';


class TemplateWidget extends StatelessWidget {
  final Widget? headerWidget;
  final RxList<MaterialModel> materialList;

  const TemplateWidget({
    Key? key, 
    required this.headerWidget,
    required this.materialList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
        child: headerWidget,
      ),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin:  const EdgeInsets.all(8.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.onSurface,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Obx(() => GridView.extent(
            maxCrossAxisExtent: 300.0,
            children: materialList.map((element) => MaterialPreview(
              item: element,
            )).toList(),
          )),
        ),
      ),
    ],
  );
}