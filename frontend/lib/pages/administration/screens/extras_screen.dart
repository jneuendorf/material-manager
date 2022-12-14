import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/pages/administration/dialogs/update_imprint_dialog.dart';
import 'package:frontend/pages/administration/dialogs/update_privacy_policy_dialog.dart';
import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/common/core/models.dart';
import 'package:frontend/common/util.dart';


class ExtrasScreen extends StatelessWidget {
  const ExtrasScreen({super.key});

  static final administartionPageController = Get.find<AdministrationPageController>();

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
        onPressed: () async {
          final String fileName = 'materials-${DateFormat('dd-MM-yyyy_hh-mm').format(DateTime.now())}.csv';
          final bytes = administartionPageController.materialController.materials.toCSV().codeUnits;
          if (!await downloadBytes(fileName, bytes)){
            Get.snackbar('error'.tr, 'unknown_error_occurred'.tr);
          }
        },
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
              'Thorsten Thorpe',
              'Karin Thorpe',
            ],
            disputeResolutionURI: Uri.parse('https://www.google.com'),
          ),
        )),
        child: Text('edit'.tr,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ),
    ListTile(
      onTap: () {}, // needed for hover effect
      hoverColor: Get.theme.colorScheme.primary.withOpacity(0.12),
      title: Text('edit_privacy_policy'.tr),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Get.theme.colorScheme.onSecondary),
        onPressed: () => Get.dialog(UpdatePrivacyPolicyDialog(
          privacypolicy: PrivacyPolicyModel(
            firstName: 'First Name',
            lastName: 'Last Name',
            company: 'Company',
            phoneNumber: '0123456789',
            email: 'club@clubs.de',
            address: Address(
              street: 'Street',
              houseNumber: '1',
              zip: '12345',
              city: 'City',
            ),
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