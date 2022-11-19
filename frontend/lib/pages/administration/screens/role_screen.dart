import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';

import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/pages/administration/dialogs/add_role_dialog.dart';
import 'package:frontend/common/buttons/text_icon_button.dart';


class RoleScreen extends StatelessWidget {
  const RoleScreen({Key? key}) : super(key: key);

  static final administrationPageController = Get.find<AdministrationPageController>();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          TextIconButton(
            onTap: () => Get.dialog(AddRoleDialog()),
            iconData: Icons.add,
            text: 'add_role'.tr,
            color: Get.theme.colorScheme.onSecondary,
          ),
        ],
      ),
      const SizedBox(height: 16.0),
      Expanded(
        child: DataTable2(
          headingRowHeight: 30.0,
          showCheckboxColumn: false,
          dataRowColor: MaterialStateProperty.resolveWith(
            administrationPageController.getDataRowColor),
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
                'permissions'.tr,
              ),
            ),
          ],
          rows: administrationPageController.userController.roles.map(
            (Role role) => DataRow(
              cells: [
                DataCell(Text(role.name)),
                DataCell(Text(role.description)),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text(role.permissions.map((p) => p.name).toList().join(', '))),
                    IconButton(
                      onPressed: () {}, 
                      icon: Icon(Icons.edit, 
                        color: Get.theme.colorScheme.onSecondary,
                      ),
                      splashRadius: 18.0,
                    ),
                  ],
                )),
              ],
              onSelectChanged: (_) {}, // needed for hover effect
            ),
          ).toList(),
        ),
      ),
    ],
  );
}
