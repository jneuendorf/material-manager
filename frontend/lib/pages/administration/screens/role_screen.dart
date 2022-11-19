import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';

import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/pages/administration/dialogs/add_role_dialog.dart';
import 'package:frontend/common/buttons/text_icon_button.dart';
import 'package:frontend/common/util.dart';


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
          columnSpacing: isLargeScreen(context) ? 56.0 : 4.0,
          horizontalMargin: isLargeScreen(context) ? 24.0 : 8.0,
          dataRowHeight: isLargeScreen(context) ? 48.0 : 80.0, 
          // TODO renove hardcoded dataRowHeight 
          // and SingleChildScrollView around description Text
          columns: <DataColumn>[
            DataColumn(
              label: Text('name'.tr),
            ),
            DataColumn(
              label: Text('description'.tr),
            ),
            DataColumn(
              label: Text('permissions'.tr),
            ),
          ],
          rows: administrationPageController.userController.roles.map(
            (Role role) => DataRow(
              cells: [
                DataCell(Text(role.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
                DataCell(Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SingleChildScrollView(child: Text(role.description)),
                )),
                DataCell(buildRolePermissions(role)),
              ],
              onSelectChanged: (_) {
                if (!isLargeScreen(context)) {
                  onRowTap(context, 
                    administrationPageController.userController.roles.indexOf(role));
                }
              },
            ),
          ).toList(),
        ),
      ),
    ],
  );

  void onRowTap(BuildContext context, int index) {
    final RenderBox widget = context.findRenderObject()! as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final Offset offset = Offset(
      widget.size.width,
      50.0 * (index + 1),
    );
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        widget.localToGlobal(offset, ancestor: overlay),
        widget.localToGlobal(widget.size.bottomRight(offset) + Offset.zero, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context, 
      position: position, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      items: [
        PopupMenuItem(
          onTap: () => administrationPageController.onEditRolePressed(
            administrationPageController.userController.roles[index]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('edit'.tr),
              Icon(Icons.edit, color: Get.theme.colorScheme.onSecondary),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildRolePermissions(Role role) {
    if (isLargeScreen(Get.context!)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(role.permissions.map(
              (Permission p) => p.name).toList().join(', '),
            ),
          ),
          IconButton(
            onPressed: () => administrationPageController.onEditRolePressed(role),
            tooltip: 'edit'.tr,
            splashRadius: 18.0,
            icon: Icon(Icons.edit, 
              color: Get.theme.colorScheme.onSecondary,
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: role.permissions.map(
          (Permission p) => Text(p.name,
            maxLines: 1, 
            overflow: TextOverflow.ellipsis,
          ),
        ).toList(),
      );
    }
  }

}
