import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/pages/lender/controller.dart';
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
          Expanded(child: Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Text('order_number'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
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
              lenderPageController.filteredRentals.length,
              (index) => GlobalKey<CollapsableExpansionTileState>(),
            );
            return ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: lenderPageController.filteredRentals.length,
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemBuilder: (context, index) => CollapsableExpansionTile(
                key: keys[index],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    List<GlobalKey<CollapsableExpansionTileState>> otherKeys = keys.where(
                      (key) => key != keys[index]
                    ).toList();

                    for (var key in otherKeys) {
                      if (key.currentState!.tileIsExpanded.value) {
                        key.currentState!.collapse();
                      }
                    }
                  }
                },
                title: buildTileTitle(lenderPageController.filteredRentals[index].obs),
                children: [
                  buildExpansionCard(lenderPageController.filteredRentals[index], context),
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
          options: [

            'all'.tr,
            ...lenderPageController.statusOptions.values
          ],
          selected: item.value.status!.name,
          onSelected: (String value) {
            // TODO: update rentalStatus
          },
        )),
      ),
    ],
  );
  Widget buildExpansionCard(RentalModel item, BuildContext context) => Card(
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Container(
      margin: const EdgeInsets.all(10.0),
      //height: 325,
      constraints: BoxConstraints(
        maxHeight: isLargeScreen(context) ? 325 : 400,
      ),
      // LargeScreen
      child: isLargeScreen(context) ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: SelectableText(lenderPageController.getUserName(item)),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('${'membership_number'.tr} : ',
                      style:  const TextStyle(color: Colors.black45),
                    ),
                    SelectableText(lenderPageController.getMembershipNum(item)),
                  ],
                ),
                Row(
                  children: [
                    Text('${'rental_period'.tr} : ',
                      style: const TextStyle(color: Colors.black45),
                    ),
                    SelectableText(lenderPageController.getRentalPeriod(item)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('${'order_number'.tr} : ',
                      style: const TextStyle(color: Colors.black45),
                    ),
                    SelectableText(item.id.toString())
                  ],
                ),
                Row(
                  children: [
                    Text('${'usage_period'.tr} : ',
                      style: const TextStyle(color: Colors.black45),
                    ),
                    SelectableText(lenderPageController.getUsagePeriod(item)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                Text('${'order_date'.tr} : ',
                  style:  const TextStyle(color: Colors.black45),
                ),
                SelectableText(formatDate(item.createdAt)),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: item.materialIds.isNotEmpty ? buildMaterialListView(item): Center(
                    child: Text('no_items_assigned_to_this_rental_entry'.tr),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 30.0),
                          Expanded(
                            child: TextFormField(
                              enabled: false,
                              initialValue: '€ ${item.cost.toStringAsFixed(2)}',
                              decoration: InputDecoration(
                                labelText: 'total'.tr,
                              ),
                            ),
                          ),
                          const SizedBox(width: 50.0),
                        ],
                      ),
                      CupertinoButton(
                        onPressed: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.5),
                            child: Text('confirm'.tr,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                      ),
                    ],
                  )
                )
              ],
            ),
          ),
        ],
        //smallScreen
      ) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: SelectableText(lenderPageController.getUserName(item)),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('${'membership_number'.tr} : ',
                      style:  const TextStyle(color: Colors.black45),
                    ),
                    SelectableText(lenderPageController.getMembershipNum(item)),
                  ],
                ),

                Row(
                  children: [
                    Text('${'order_number'.tr} : ',
                      style: const TextStyle(color: Colors.black45),
                    ),
                    SelectableText(item.id.toString())
                  ],
                ),
                Row(
                  children: [
                    Text('${'order_date'.tr} : ',
                      style:  const TextStyle(color: Colors.black45),
                    ),
                    SelectableText(formatDate(item.createdAt)),
                  ],
                ),
                Row(
                  children: [
                    Text('${'rental_period'.tr} : ',
                      style: const TextStyle(color: Colors.black45),
                    ),
                    SelectableText(lenderPageController.getRentalPeriod(item)),
                  ],
                ),
                Row(
                  children: [
                    Text('${'usage_period'.tr} : ',
                      style: const TextStyle(color: Colors.black45),
                    ),
                    SelectableText(lenderPageController.getUsagePeriod(item)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Flexible(
                  //flex: 3,
                  child: item.materialIds.isNotEmpty ? buildMaterialListView(item) : Center(
                    child: Text('no_items_assigned_to_this_rental_entry'.tr),
                  ),
                ),
                Expanded(
                    //flex: 1,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 30.0),
                            Expanded(
                              child: TextFormField(
                                enabled: false,
                                initialValue: '€ ${item.cost.toStringAsFixed(2)}',
                                decoration: InputDecoration(
                                  labelText: 'total'.tr,
                                ),
                              ),
                            ),
                            const SizedBox(width: 50.0),
                          ],
                        ),
                        CupertinoButton(
                            onPressed: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.5),
                                child: Text('confirm'.tr,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                        ),
                      ],
                    )
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget buildMaterialListView(RentalModel item) => ListView.separated(
    shrinkWrap: true,
    separatorBuilder: (context, index) => const Divider(),
    itemCount: item.materialIds.length,
    itemBuilder: (context, localIndex) {
      String? imageUrl = lenderPageController.getMaterialPicture(item,localIndex);
      return ListTile(
        leading: imageUrl != null
            ? Image.network(baseUrl + imageUrl)
            : const Icon(Icons.image),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(lenderPageController.getItemName(item,localIndex))),
            Expanded(
              child: Center(
                child: Obx(() => DropDownFilterButton(
                  options: lenderPageController.statusOptions.values.toList(),
                  selected: item.status!.name,
                  onSelected: (String value) {
                    // TODO: update rentalStatus of item
                  },
                )),
              ),
            ),
            Flexible(
              child: Theme(
                data: ThemeData(
                    outlinedButtonTheme: OutlinedButtonThemeData(
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.black)
                    )
                ) ,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 100),
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: go to inspection page for the selected item
                      },
                      child: Text('inspect'.tr,maxLines: 1),
                    ),
                  ),
                ),
              ),
            ),
            Text('€ ${lenderPageController.getItemPrice(item,localIndex)}'),
          ],
        ),
      );
    },
  );
}
