import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';

import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/pages/administration/dialogs/add_user_dialog.dart';
import 'package:frontend/common/buttons/drop_down_filter_button.dart';
import 'package:frontend/common/buttons/text_icon_button.dart';


class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

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
                ...administrationPageController.userController.roles.map((e) => e.name)
              ],
              selected: administrationPageController.selectedFilter.value?.name ?? 'all'.tr,
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
                  administrationPageController.searchTerm.value = text;
                  administrationPageController.runFilter();
                },
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          TextIconButton(
            onTap: () => Get.dialog(AddUserDialog()), 
            iconData: Icons.add, 
            text: 'add_user'.tr,
            color: Get.theme.colorScheme.onSecondary,
          ),
        ],
      ),
      const SizedBox(height: 16.0),
      Expanded(
        child: Obx(() => DataTable2(
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
                'membership_number'.tr,
              ),
            ),
            DataColumn(
              label: Text(
                'role'.tr,
              ),
            ),
          ],
          rows: administrationPageController.filteredUsers.map(
            (UserModel user) => DataRow(
              cells: [
                DataCell(Text('${user.firstName} ${user.lastName}')),
                DataCell(Text(user.membershipNumber.toString())),
                DataCell(Text(user.roles.map(
                  (Role r) => r.name).toList().join(', '),
                )),
              ],
              onSelectChanged: (_) {
                administrationPageController.selectedUser.value = user;
                Get.toNamed(administrationAccountDetailRoute);
              },
            ),
          ).toList(),
        )),
      ),
    ],
  );
}
