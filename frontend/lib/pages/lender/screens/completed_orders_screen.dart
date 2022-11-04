import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/pages/lender/controller.dart';
import 'package:frontend/common/components/collapsable_expansion_tile.dart';


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
        ],
      ),
      const Divider(),
      Expanded(
        child: Obx(() {
          final List<GlobalKey<CollapsableExpansionTileState>> keys = List.generate(
            lenderPageController.filteredRentals.length, (index) => GlobalKey<CollapsableExpansionTileState>(),
          );
          return ListView.separated(
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
              title: Row(
                children: [
                  Expanded(child: Text(lenderPageController.filteredRentals[index].id.toString())),
                  Expanded(child: Text('€ ${lenderPageController.filteredRentals[index].cost.toString()}')),
                  Expanded(child: Text(lenderPageController.formatDate(lenderPageController.filteredRentals[index].createdAt))),
                  Expanded(
                    child: Center(
                      child: Row(
                        children: [
                          Text('completed'.tr)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              children: [
                buildExpansionCard(lenderPageController.filteredRentals[index]),
              ],
            ),
          );
        }),
      ),
    ],
  );

  Widget buildExpansionCard(RentalModel item) => Card(
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Container(
      margin: const EdgeInsets.all(10.0),
      //height: 325,
      constraints: const BoxConstraints(
        maxHeight: 325,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: SelectableText(getUserName(item)),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('${'membership_number'.tr} : ',style:  const TextStyle(color: Colors.black45)),
                    SelectableText(getMembershipNum(item)),
                  ],
                ),
                Row(
                  children: [
                    Text('${'order_date'.tr} : ',style:  const TextStyle(color: Colors.black45)),
                    SelectableText( lenderPageController.formatDate(item.createdAt)),
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
                    Text('${'order_number'.tr} : ', style: const TextStyle(color: Colors.black45)),
                    SelectableText(item.id.toString())
                  ],
                ),
                Row(
                  children: [
                    Text('${'rental_period'.tr} : ', style: const TextStyle(color: Colors.black45)),
                    SelectableText(getRentalPeriod(item)),
                  ],
                )
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
                    Text('${'usage_period'.tr} : ', style: const TextStyle(color: Colors.black45),),
                    SelectableText(getUsagePeriod(item)),
                  ],
                ),
                const SizedBox(width: 500.0),

                const SizedBox(width: 50.0),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: item.materialIds.isNotEmpty ? ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: item.materialIds.length,
                    itemBuilder: (context, localIndex) => ListTile(
                      leading: Image.network(getMaterialPicture(item,localIndex)),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(getItemName(item,localIndex))),
                          Expanded(
                            child: Center(
                              child: SizedBox(
                                width: 100,
                                child: Text('completed'.tr)
                              ),
                            ),
                          ),
                          Expanded(child: Text('${getItemPrice(item,localIndex)} €'))
                        ],
                      ),
                    ),
                  ): Container(),
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
                                initialValue: '${item.cost.toString()} €',
                                decoration: InputDecoration(
                                  labelText: 'sum'.tr,
                                ),
                              ),
                            ),
                            const SizedBox(width: 50.0),
                          ],
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

  String getUserName(RentalModel item) {
    String userName = '${lenderPageController.userController.users.firstWhere(
            (UserModel user) => user.id == item.id).firstName} '
        '${lenderPageController.userController.users.firstWhere(
            (UserModel user) => user.id == item.id).lastName}';
    return userName;
  }

  String getMembershipNum(RentalModel item) {
    String membershipNum = lenderPageController.userController.users.firstWhere((UserModel user) =>
    user.id == item.id).membershipNumber.toString();
    return membershipNum;
  }

  String getRentalPeriod(RentalModel item) {
    String rentalPeriod = '${lenderPageController.formatDate(item.startDate)} ${' - '} ${lenderPageController.formatDate(item.endDate)}';
    return rentalPeriod;
  }

  String getUsagePeriod(RentalModel item) {
    String rentalPeriod = '${lenderPageController.formatDate(item.usageStartDate)} ${' - '} ${lenderPageController.formatDate(item.usageEndDate)}';
    return rentalPeriod;
  }

  String getMaterialPicture(RentalModel item, int localIndex) {
    String path = lenderPageController.materialController.materials.firstWhere((MaterialModel material) =>
    material.id == item.materialIds[localIndex]).imagePath!;
    return path;
  }

  String getItemName(RentalModel item, int localIndex) {
    String itemName = lenderPageController.materialController.materials.firstWhere((MaterialModel material) =>
    material.id == item.materialIds[localIndex]).equipmentType.description;
    return itemName;
  }

  String getItemPrice(RentalModel item, int localIndex) {
    String itemPrice = lenderPageController.materialController.materials.firstWhere((MaterialModel material) =>
    material.id == item.materialIds[localIndex]).rentalFee.toString();
    return itemPrice;
  }

}
