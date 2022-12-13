import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/components/base_footer.dart';
import 'package:frontend/common/core/controller.dart';


const privacyPolicyRoute = '/privacyPolicy';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static final coreController = Get.find<CoreController>();

  @override
  Widget build(BuildContext context) => PageWrapper(
    showFooter: false,
    child: SingleChildScrollView(
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
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Text('privacy_policy'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 35.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text('1_privacy_at_a_glance'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 30.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('general_information'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text('general_information_text'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text('data_collection_on_this_site'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
                child: Text('responsible_for_data_collection'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('responsible_for_data_collection_text'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:10.0,bottom: 10.0),
                child: Text('data_collection'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('data_collection_text1'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('data_collection_text2'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:10.0,bottom: 10.0),
                child: Text('data_usage'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('data_usage_text'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:10.0,bottom: 10.0),
                child: Text('data_rights'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('data_rights_text'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0,bottom: 15.0),
                child: Text('2_general_information_and_mandatory_information'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 30.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text('privacy'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('privacy_text1'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('privacy_text2'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('privacy_text3'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                child: Text('responsible_entity'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('responsible_entity_text1'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('${coreController.privacyPolicy.value!.company?? ''}\n${coreController.privacyPolicy.value!.firstName} ${coreController.privacyPolicy.value!.lastName} \n${coreController.privacyPolicy.value!.address.street} ${coreController.privacyPolicy.value!.address.houseNumber} \n${coreController.privacyPolicy.value!.address.zip} ${coreController.privacyPolicy.value!.address.city}',
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('${'email'.tr}: ${coreController.privacyPolicy.value!.email}',
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              if (coreController.privacyPolicy.value!.phoneNumber != null) Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('${'phone'.tr}: ${coreController.privacyPolicy.value!.phoneNumber}',
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('responsible_entity_text2'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                child: Text('storage_duration'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('storage_duration_text'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                child: Text('general_information_legal_basis'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('general_information_legal_basis_text'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                child: Text('revocation_of_consent'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('revocation_of_consent_text'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                child: Text('right_to_object'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('right_to_object_text1'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('right_to_object_text2'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                child: Text('right_to_appeal'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('right_to_appeal_text'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                child: Text('right_to_data_portability'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('right_to_data_portability_text'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                child: Text('information_deletion_correction'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('information_deletion_correction_text'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                child: Text('right_to_restricting_processing'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('right_to_restricting_processing_text1'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('right_to_restricting_processing_point1'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('right_to_restricting_processing_point2'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('right_to_restricting_processing_point3'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('right_to_restricting_processing_point4'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('right_to_restricting_processing_text2'.tr,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              const BaseFooter(),
            ],
          );
        },
      ),
    ),
  );
}
