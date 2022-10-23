import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/extensions/rental/model.dart';

import 'package:get/get.dart';
import 'package:frontend/pages/lender/controller.dart';
import 'package:frontend/common/buttons/drop_down_filter_button.dart';

class ActiveOrderScreen extends StatelessWidget {
  const ActiveOrderScreen({Key? key}) : super(key: key);
  static final lenderPageController = Get.find<LenderPageController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            SelectableText('test'),
            SizedBox(width: 270.0),
            SelectableText('test'),
            SizedBox(width: 270.0),
            SelectableText('test'),
            SizedBox(width: 270.0),
            SelectableText('test'),
          ],
        ),
        const Divider(),
        Expanded(
          child: ListView.separated(
              itemCount: lenderPageController.availableRentals.length,
              itemBuilder: (context, index)  {
                  return Container(
                  margin: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectableText('test'),
                      SelectableText('test'),
                      SelectableText('test'),
                      Obx(() => DropDownFilterButton(
                        title: 'status'.tr,
                        options: [
                          'all'.tr,
                          ...lenderPageController.availableRentals.map((e) => e.status.toString())
                        ],
                        selected: lenderPageController.rentalStatus.value?.name ?? 'all'.tr,
                        onSelected: lenderPageController.onFilterSelected,
                      )),
                    ],
                  ),
                );
              }, separatorBuilder: (BuildContext context, int index) => const Divider()
          ),
        ),
      ],
    );
  }
}
