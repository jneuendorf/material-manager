import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';

import 'package:frontend/pages/lender/controller.dart';

class CompletedOrdersScreen extends StatelessWidget {
  const CompletedOrdersScreen({Key? key}) : super(key: key);
  static final lenderPageController = Get.find<LenderPageController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: DataTable2(
            headingRowHeight: 30.0,
            columns: <DataColumn>[
              DataColumn(
                label: Text(
                  'name'.tr,
                ),
              ),
              DataColumn(
                label: Text(
                  'membership_number'.tr,
                ),
              ),
              DataColumn(
                label: Text(
                  'role'.tr,
                ),
              ),
            ],
            rows: const <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(Text('')),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
