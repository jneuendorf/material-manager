import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/pages/lender/controller.dart';
import 'package:frontend/pages/lender/components/expansion_tile_body.dart';
import 'package:frontend/common/buttons/drop_down_filter_button.dart';
import 'package:frontend/common/components/collapsable_expansion_tile.dart';
import 'package:frontend/common/util.dart';


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
          const SizedBox(width: 50.0),
        ],
      ),
      const Divider(),
      Expanded(
        child: Obx(() {
          final List<GlobalKey<CollapsableExpansionTileState>> keys = List.generate(
            lenderPageController.activeRentals.length,
            (index) => GlobalKey<CollapsableExpansionTileState>(),
          );
          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: lenderPageController.activeRentals.length,
            separatorBuilder: (BuildContext context, int index) => const Divider(),
            itemBuilder: (context, index) => CollapsableExpansionTile(
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
              title: buildTileTitle(lenderPageController.activeRentals[index].obs),
              children: [
                ExpansionTileBody(item: lenderPageController.activeRentals[index]),
              ],
            ),
          );
        }),
      ),
    ],
  );

  Widget buildTileTitle(Rx<RentalModel> item) => Row(
    children: [
      Expanded(flex: 19, child: Text(item.value.id.toString())),
      Expanded(flex: 20, child: Text('€ ${item.value.cost.toStringAsFixed(2)}')),
      Expanded(flex: 20, child: Text(formatDate(item.value.createdAt),
        overflow: TextOverflow.ellipsis
      )),
      Flexible(
        flex: 20,
        child: Obx(() => DropDownFilterButton(
          options: RentalStatus.values.map((status) => status.name).toList(),
          selected: item.value.status!.name,
          onSelected: (String value) => lenderPageController.onRentalStatusChanged(value, item),
        )),
      ),
    ],
  );

}
