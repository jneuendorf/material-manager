import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/lender/controller.dart';
import 'package:frontend/pages/lender/components/expansion_tile_body.dart';
import 'package:frontend/common/components/collapsable_expansion_tile.dart';
import 'package:frontend/common/util.dart';


class CompletedOrdersScreen extends StatelessWidget {
  const CompletedOrdersScreen({Key? key}) : super(key: key);

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
          const SizedBox(width: 50.0),
        ],
      ),
      const Divider(),
      Expanded(
        child: Obx(() {
          final List<GlobalKey<CollapsableExpansionTileState>> keys = List.generate(
            lenderPageController.completedRentals.length, (index) => GlobalKey<CollapsableExpansionTileState>(),
          );
          return ListView.separated(
            itemCount: lenderPageController.completedRentals.length,
            separatorBuilder: (BuildContext context, int index) => const Divider(),
            itemBuilder: (BuildContext context, int index) => CollapsableExpansionTile(
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
                  Expanded(
                    flex: 19,
                    child: Text(lenderPageController.completedRentals[index].id.toString()),
                  ),
                  Expanded(
                    flex: 20,
                    child: Text('€ ${lenderPageController.completedRentals[index].cost.toStringAsFixed(2)}'),
                  ),
                  Expanded(
                    flex: 20,
                    child: Text(formatDate(lenderPageController.completedRentals[index].createdAt)),
                  ),
                  Expanded(
                    flex: 20,
                    child: Text('completed'.tr),
                  ),
                ],
              ),
              children: [
                ExpansionTileBody(item: lenderPageController.completedRentals[index], completed: true)
              ],
            ),
          );
        }),
      ),
    ],
  );
}
