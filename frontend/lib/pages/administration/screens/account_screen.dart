import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';

import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/common/buttons/drop_down_filter_button.dart';
import 'package:frontend/common/util.dart';


class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  static final administrationPageController = Get.find<AdministrationPageController>();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
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
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isLargeScreen(context) ? 32.0 : 8.0,
              ),
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
          columnSpacing: isLargeScreen(context) ? 56.0 : 4.0,
          horizontalMargin: isLargeScreen(context) ? 24.0 : 8.0,
          columns: <DataColumn>[
            DataColumn(
              label: Text('name'.tr),
            ),
            DataColumn(
              label: Text(isLargeScreen(context) 
                ? 'membership_number'.tr : 'member_number'.tr,
              ),
            ),
            DataColumn(
              label: Text('role'.tr),
            ),
          ],
          rows: administrationPageController.filteredUsers.map(
            (UserModel user) => DataRow(
              onSelectChanged: (_) {
                administrationPageController.selectedUser.value = user;
                Get.toNamed(administrationAccountDetailRoute);
              },
              cells: [
                DataCell(Text('${user.firstName} ${user.lastName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
                DataCell(Text(user.membershipNumber.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
                DataCell(buildUserRoles(user.roles)),
              ],
            ),
          ).toList(),
        )),
      ),
    ],
  );

  Widget buildUserRoles(List<Role> roles) {
    if (isLargeScreen(Get.context!)) {
      return Text(roles.map(
        (Role r) => r.name).toList().join(', '),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: roles.map(
          (Role r) => Text(r.name, 
            maxLines: 1, 
            overflow: TextOverflow.ellipsis,
          ),
        ).toList(),
      );
    }
  }
}
