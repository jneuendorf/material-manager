import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/lender/controller.dart';
import 'package:frontend/common/buttons/drop_down_filter_button.dart';
import 'package:frontend/common/components/collapsable_expansion_tile.dart';


class ActiveOrderScreen extends StatelessWidget {
  const ActiveOrderScreen({Key? key}) : super(key: key);

  static final lenderPageController = Get.find<LenderPageController>();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(child: Text('order_number'.tr, 
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          Expanded(child: Text('price'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          Expanded(child: Text('order_date'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          Expanded(child: Text('status'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
        ],
      ),
      const Divider(),
      Expanded(
        child: Obx(() => ListView.separated(
            itemCount: lenderPageController.filteredRentals.length,
            itemBuilder: (context, index)  => CollapsableExpansionTile(
              key: lenderPageController.keys[index],
              onExpansionChanged: (bool expanded) {
                if (expanded) {
                  List<GlobalKey<CollapsableExpansionTileState>> otherKeys = lenderPageController.keys.where(
                    (key) => key != lenderPageController.keys[index]
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
                  Expanded(child: Text(lenderPageController.filteredRentals[index].id.toString())),
                  Expanded(child: Text('€ ${lenderPageController.filteredRentals[index].cost.toString()}')),
                  Expanded(child: Text(lenderPageController.formatDate(lenderPageController.filteredRentals[index].createdAt))),
                  Expanded(
                    child: Center(
                      child: Row(
                        children: [
                          Obx(() => DropDownFilterButton(
                            options: [
                              'all'.tr,
                              ...lenderPageController.availableStatuses.map((e) => e.name)
                            ],
                            selected: lenderPageController.filteredRentals[index].status!.name,
                            onSelected: lenderPageController.onFilterSelected,
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              children: [
                Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 200,
                  ),
                ),
              ],
            ), 
            separatorBuilder: (BuildContext context, int index) => const Divider()
        )),
      ),
    ],
  );
}
