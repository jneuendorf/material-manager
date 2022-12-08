import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/components/base_footer.dart';
import 'package:frontend/common/core/controller.dart';


const imprintRoute = '/imprint';

class ImprintPage extends StatelessWidget {
  const ImprintPage({super.key});

  static final coreController = Get.find<CoreController>();

  @override
  Widget build(BuildContext context) => PageWrapper(
    showFooter: false,
    child: Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                child: FutureBuilder(
                  future: coreController.initCompleter.future,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('imprint'.tr, 
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 35.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 35.0, bottom: 15.0),
                          child: Text(coreController.imprint.value!.clubName, 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 9.0),
                          child: Text('${coreController.imprint.value!.address.street} ${coreController.imprint.value!.address.houseNumber}, ${coreController.imprint.value!.address.zip} ${coreController.imprint.value!.address.city}',
                            style: const TextStyle(fontSize: 15.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 9.0),
                          child: Text('${'phone'.tr}: ${coreController.imprint.value!.phoneNumber}',
                            style: const TextStyle(fontSize: 15.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 9.0),
                          child: Text('${'email'.tr}: ${coreController.imprint.value!.email}',
                            style: const TextStyle(fontSize: 15.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0, bottom: 5.0),
                          child: Text('authorized_board_of_directors'.tr,
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        for(String boardMember in coreController.imprint.value!.boardMembers)
                          Text(boardMember, style: const TextStyle(fontSize: 15.0)),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0, bottom: 5.0),
                          child: Text('registered_in_club_register'.tr,
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text('${coreController.imprint.value!.registryCourt}: ${coreController.imprint.value!.registrationNumber}', 
                          style: const TextStyle(fontSize: 15.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0, bottom: 5.0),
                          child: Text('vat_number'.tr,
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(coreController.imprint.value!.vatNumber,
                          style: const TextStyle(fontSize: 15.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0, bottom: 5.0),
                          child: Text('regulation_on_online_dispute_resolution_in_consumer_matters'.tr, 
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text('dispute_resolution_text'.tr,
                          style: const TextStyle(fontSize: 15.0),
                        ),
                        InkWell(
                          onTap: () async {
                            if (!await launchUrl(coreController.imprint.value!.disputeResolutionURI)) {
                              Get.snackbar('error'.tr, 'could_not_launch_url'.tr);
                            }
                          },
                          child: Text(coreController.imprint.value!.disputeResolutionURI.toString(),
                            style: TextStyle(fontSize: 15.0, color: Get.theme.colorScheme.onSecondary),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0, bottom: 5.0),
                          child: Text('liability_note'.tr, 
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text('liability_note_text'.tr,
                          style: const TextStyle(fontSize: 15.0),
                        ),
                      ],
                    );
                  }
                ),
              ),
            ),
            const Padding(
              padding:  EdgeInsets.only(top: 32.0),
              child: BaseFooter(),
            ),
          ],
        ),
      ),
    ),
  );
}