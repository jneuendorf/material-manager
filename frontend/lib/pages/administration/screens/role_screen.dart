import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';

import 'package:frontend/common/buttons/drop_down_filter_button.dart';
import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/extensions/user/model.dart';


class RoleScreen extends StatelessWidget {
  const RoleScreen({Key? key}) : super(key: key);
  static final administrationPageController = Get.find<AdministrationPageController>();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => DropDownFilterButton(
            title: 'roles'.tr,
            options: [
              'all'.tr,
              ...administrationPageController.roles.map((e) => e.name)
            ],
            selected: administrationPageController.selectedFilter.value?.description ?? 'all'.tr,
            onSelected: administrationPageController.onFilterSelected,
          )),
          const SizedBox(width: 16.0),
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 200.0,
                maxWidth: 300.0,
              ),
              child: CupertinoSearchTextField(
                placeholder: 'search'.tr,
                onChanged: (String text) {

                },
              ),
            ),
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      const SizedBox(height: 16.0),
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
                'description'.tr,
              ),
            ),
            DataColumn(
              label: Text(
                'rights'.tr,
              ),
            ),
            /*const DataColumn(
              label: Text(''),
            ),*/
          ],
          rows: administrationPageController.roles.map(
                (Role role) => DataRow(
              cells: [
                DataCell(Text(role.name)),
                DataCell(Text(role.description)),
                DataCell(Row(
                  children: [
                    Text(role.rights.map((e) => e.name).toList().join(', ')),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      splashRadius: 16.0,
                      onPressed: () {},
                    ),
                  ],
                )),
              ],
            ),
          ).toList(),
        ),
      ),
    ],
  );
}
