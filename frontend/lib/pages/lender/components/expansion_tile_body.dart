import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/pages/lender/controller.dart';
import 'package:frontend/pages/lender/components/selectable_text_row.dart';
import 'package:frontend/common/buttons/drop_down_filter_button.dart';
import 'package:frontend/common/util.dart';


class ExpansionTileBody extends StatelessWidget {
  final RentalModel item;
  final bool completed;

  const ExpansionTileBody({
    super.key, 
    required this.item, 
    this.completed = false,
  });

  static final lenderPageController = Get.find<LenderPageController>();

  @override
  Widget build(BuildContext context) => Card(
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Container(
      margin: const EdgeInsets.all(10.0),
      constraints: BoxConstraints(
        maxHeight: isLargeScreen(context) ? 325 : 400,
      ),
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
                SelectableTextRow(
                  title: 'membership_number'.tr,
                  value: lenderPageController.getMembershipNum(item),
                ),
                SelectableTextRow(
                  title: 'rental_period'.tr,
                  value: lenderPageController.getRentalPeriod(item),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SelectableTextRow(
                  title: 'order_number'.tr,
                  value: item.id.toString(),
                ),
                SelectableTextRow(
                  title: 'usage_period'.tr,
                  value: lenderPageController.getUsagePeriod(item),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: SelectableTextRow(
              title: 'order_date'.tr,
              value: formatDate(item.createdAt),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: item.materialIds.isNotEmpty
                    ? buildMaterialListView(item.obs, completed: completed)
                    : Center(
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
                      if (!completed)  CupertinoButton(
                        onPressed: () {}, // TODO implement confirm rental
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
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: SelectableText(lenderPageController.getUserName(item)),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: SizedBox(
              height: 120.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableTextRow(
                    title: 'membership_number'.tr,
                    value: lenderPageController.getMembershipNum(item),
                  ),
                  SelectableTextRow(
                    title: 'order_number'.tr,
                    value: item.id.toString(),
                  ),
                  SelectableTextRow(
                    title: 'order_date'.tr,
                    value: formatDate(item.createdAt),
                  ),
                  SelectableTextRow(
                    title: 'rental_period'.tr,
                    value: lenderPageController.getRentalPeriod(item),
                  ),
                  SelectableTextRow(
                    title: 'usage_period'.tr,
                    value: lenderPageController.getUsagePeriod(item),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Flexible(
                  child: item.materialIds.isNotEmpty 
                    ? buildMaterialListView(item.obs, completed: completed) 
                    : Center(
                      child: Text('no_items_assigned_to_this_rental_entry'.tr),
                    ),
                ),
                Expanded(
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
                      if (!completed) CupertinoButton(
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
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget buildMaterialListView(Rx<RentalModel> item, {bool completed = false}) => ListView.separated(
    shrinkWrap: true,
    separatorBuilder: (context, index) => const Divider(),
    itemCount: item.value.materialIds.length,
    itemBuilder: (context, index) {
      String? imageUrl = lenderPageController.getMaterialPicture(item.value, index);
      return ListTile(
        leading: imageUrl != null
            ? Image.network(baseUrl + imageUrl)
            : const Icon(Icons.image),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(lenderPageController.getItemName(item.value, index))),
            Expanded(
              child: !completed ? Center(
                child: Obx(() => DropDownFilterButton(
                  options: ConditionModel.values.map((condition) => condition.name).toList(),
                  selected: lenderPageController.getMaterialCondition(item.value.materialIds[index]),
                  onSelected: (String value) => lenderPageController.onMaterialConditionChanged(value, item.value, item.value.materialIds[index]),
                )),
              ) : const SizedBox(),
            ),
            !completed ? Flexible(
              child: Theme(
                data: ThemeData(
                  outlinedButtonTheme: OutlinedButtonThemeData(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.black)
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 100),
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO go to inspection page for the selected item
                      },
                      child: Text('inspect'.tr,maxLines: 1),
                    ),
                  ),
                ),
              ),
            ) : Center(
              child: SizedBox(
                  width: 100,
                  child: Text('completed'.tr)
              ),
            ),
            Text('€ ${lenderPageController.getItemPrice(item.value, index)}'),
          ],
        ),
      );
    },
  );

}
