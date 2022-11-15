import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';

import 'package:frontend/extensions/rental/model.dart';
import 'package:frontend/extensions/rental/controller.dart';
import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/pages/profile/dialogs/cancel_rental_dialog.dart';
import 'package:frontend/common/util.dart';


class UserOrderList extends StatefulWidget {
  final UserModel user;

  const UserOrderList({
    Key? key, 
    required this.user,
  }) : super(key: key);

  @override
  State<UserOrderList> createState() => _UserOrderListState();
}

class _UserOrderListState extends State<UserOrderList> {
  final rentalController = Get.find<RentalController>();

  final RxList<RentalModel> userRentals = <RentalModel>[].obs;

  Future<void> asyncInit() async {
    await rentalController.initCompleter.future;

    userRentals.value = rentalController.rentals.where(
      (RentalModel rental) => rental.customerId == widget.user.id
    ).toList();
  }

  @override
  void initState() {
    super.initState();

    asyncInit();
  }

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        if (isLargeScreen(context)) Text('active_orders'.tr,
          style: Get.textTheme.headline6!.copyWith(fontSize: 25),
        ),
        const SizedBox(height: 16.0),
        buildActiveOrders(),
        const Divider(),
        if (isLargeScreen(context)) Text('order_history'.tr,
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
      dataRowColor: MaterialStateProperty.resolveWith(getDataRowColor),
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
      rows: userRentals.map(
            (RentalModel rental) => DataRow(
          cells: [
            DataCell(Text(rental.id.toString())),
            DataCell(Text('€ ${rental.cost.toString()}')),
            DataCell(Text(formatDate(rental.createdAt))),
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
      dataRowColor: MaterialStateProperty.resolveWith(getDataRowColor),
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
      rows: userRentals.map(
            (RentalModel rental) => DataRow(
          cells: [
            DataCell(Text(rental.id.toString())),
            DataCell(Text('€ ${rental.cost.toString()}')),
            DataCell(Text(formatDate(rental.createdAt))),
            DataCell(Text(rental.status!.name)),
          ],
          onSelectChanged: (_) {}, // needed for hover effect
        ),
      ).toList(),
    )),
  );

  String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  Color getDataRowColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };

    if (states.any(interactiveStates.contains)) {
      return Get.theme.colorScheme.primary.withOpacity(0.12);
    }

    return Colors.transparent;
  }

}
