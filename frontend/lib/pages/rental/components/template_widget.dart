import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/util.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/pages/rental/components/material_preview.dart';
import 'package:frontend/common/components/base_footer.dart';


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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                margin:  isLargeScreen(context)
                  ? const EdgeInsets.all(8.0)
                  : const EdgeInsets.symmetric(vertical: 8.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Obx(() => GridView.extent(
                  shrinkWrap: true,
                  maxCrossAxisExtent: 300.0,
                  physics: const NeverScrollableScrollPhysics(),
                  children: materialList.map((element) => MaterialPreview(
                    item: element,
                  )).toList(),
                )),
              ),
              if (kIsWeb) const BaseFooter(),
            ],
          ),
        ),
      ),
    ],
  );
}
