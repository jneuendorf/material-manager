import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/profile/dialogs/cancel_rental_dialog.dart';

import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';

import 'package:frontend/extensions/user/mock_data.dart';
import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/pages/profile/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/components/user_details_widget.dart';


class ProfilePage extends GetView<ProfilePageController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PageWrapper(
    pageTitle: 'profile'.tr,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => UserDetailsWidget(
          user: controller.currentUser.value ?? mockUsers.first,
        )),
        const SizedBox(height: 8.0),
        const Divider(),
        if (kIsWeb) Text('active_orders'.tr, 
          style: Get.textTheme.headline6!.copyWith(fontSize: 25),
        ),
        const SizedBox(height: 16.0),
        buildActiveOrders(),
        const Divider(),
        if (kIsWeb) Text('order_history'.tr, 
          style: Get.textTheme.headline6!.copyWith(fontSize: 25),
        ),
        const SizedBox(height: 16.0),
        buildOrderHistory(),
      ],
    ),
  );

  Widget buildActiveOrders() => Expanded(
    child: Obx(() => DataTable2(
      headingRowHeight: 30.0,
      dataRowColor: MaterialStateProperty.resolveWith(controller.getDataRowColor),
      showCheckboxColumn: false,
      columns: <DataColumn>[
        DataColumn(
          label: Text('order_number'.tr),
        ),
        DataColumn(
          label: Text('price'.tr),
        ),
        DataColumn(
          label: Text('order_date'.tr),
        ),
        DataColumn(
          label: Text('status'.tr),
        ),
      ],
      rows: controller.currentRentals.map(
        (RentalModel rental) => DataRow(
          cells: [
            DataCell(Text(rental.id.toString())),
            DataCell(Text('€ ${rental.cost.toString()}')),
            DataCell(Text(controller.formatDate(rental.createdAt))),
            DataCell(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(rental.status!.name)),
                IconButton(
                  onPressed: () => Get.dialog(CancelRentalDialog(rental: rental)),
                  tooltip: 'cancel'.tr,
                  icon: const Icon(CupertinoIcons.xmark,
                    color: Colors.red,
                  ),
                  splashRadius: 18.0,
                ),
              ],
            )),
          ],
          onSelectChanged: (_) {}, // needed for hover effect
        ),
      ).toList(),
    )),
  );

  Widget buildOrderHistory() => Expanded(
    child: Obx(() => DataTable2(
      headingRowHeight: 30.0,
      dataRowColor: MaterialStateProperty.resolveWith(controller.getDataRowColor),
      showCheckboxColumn: false,
      columns: <DataColumn>[
        DataColumn(
          label: Text('order_number'.tr),
        ),
        DataColumn(
          label: Text('price'.tr),
        ),
        DataColumn(
          label: Text('order_date'.tr),
        ),
        DataColumn(
          label: Text('status'.tr),
        ),
      ],
      rows: controller.currentRentals.map(
        (RentalModel rental) => DataRow(
          cells: [
            DataCell(Text(rental.id.toString())),
            DataCell(Text('€ ${rental.cost.toString()}')),
            DataCell(Text(controller.formatDate(rental.createdAt))),
            DataCell(Text(rental.status!.name)),
          ],
          onSelectChanged: (_) {}, // needed for hover effect
        ),
      ).toList(),
    )),
  );
}