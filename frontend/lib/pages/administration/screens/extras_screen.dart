import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/administration/dialogs/update_imprint_dialog.dart';
import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/common/core/models.dart';


class ExtrasScreen extends StatelessWidget {
  const ExtrasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = buildChildren();

    return ListView.separated(
      itemCount: children.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) => children[index],
    );
  }

  List<Widget> buildChildren() => [
    ListTile(
      onTap: () {}, // needed for hover effect
      hoverColor: Get.theme.colorScheme.primary.withOpacity(0.12),
      title: Text('export_inventory_to_csv'.tr),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Get.theme.colorScheme.onSecondary),
        onPressed: () {},
        child: Text('export'.tr,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),    
    ),
    ListTile(
      onTap: () {}, // needed for hover effect
      hoverColor: Get.theme.colorScheme.primary.withOpacity(0.12),
      title: Text('edit_imprint'.tr),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Get.theme.colorScheme.onSecondary),
        onPressed: () => Get.dialog(UpdateImprintDialog(
          imprint: ImprintModel(
            clubName: 'Club Name',
            phoneNumber: '0123456789',
            email: 'club@clubs.de',
            registrationNumber: 123456789,
            registryCourt: 'Registry Court',
            vatNumber: 'VAT Number',
            address: Address(
              street: 'Street',
              houseNumber: '1',
              zip: '12345',
              city: 'City',
            ),
            boardMembers: [
              BoardMember(firstName: 'Thorsten', lastName: 'Thorpe'),
              BoardMember(firstName: 'Karin', lastName: 'Thorpe')
            ],
          ),
        )),
        child: Text('edit'.tr,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ),
  ];
}