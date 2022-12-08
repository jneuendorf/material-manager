import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/common/core/models.dart';
import 'package:frontend/common/util.dart';
import 'package:frontend/common/buttons/text_icon_button.dart';


class UpdatePrivacyPolicyDialog extends StatefulWidget {
  final PrivacyPolicyModel privacypolicy;
  
  const UpdatePrivacyPolicyDialog({super.key, required this.privacypolicy});

  @override
  State<UpdatePrivacyPolicyDialog> createState() => _UpdatePrivacyPolicyDialogState();
}

class _UpdatePrivacyPolicyDialogState extends State<UpdatePrivacyPolicyDialog> {

  final TextEditingController companyController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  final GlobalKey<FormState> formKey =  GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();

    companyController.text = widget.privacypolicy.company;
    phoneController.text = widget.privacypolicy.phoneNumber;
    emailController.text = widget.privacypolicy.email;
    firstNameController.text = widget.privacypolicy.firstName;
    lastNameController.text = widget.privacypolicy.lastName;
    streetNameController.text = widget.privacypolicy.address.street;
    houseNumberController.text = widget.privacypolicy.address.houseNumber;
    cityController.text = widget.privacypolicy.address.city;
    zipController.text = widget.privacypolicy.address.zip;

  }

  @override
  Widget build(BuildContext context) => Dialog( 
    insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
            maxWidth: 600,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('edit_privacy_policy'.tr, style: Get.textTheme.headline6),
                  ),
                  IconButton(
                    onPressed: Get.back,
                    splashRadius: 20,
                    icon: const Icon(CupertinoIcons.xmark),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        labelText: 'first_name'.tr,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'first_name_is_mandatory'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        labelText: 'last_name'.tr,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'last_name_is_mandatory'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: companyController,
                      decoration: InputDecoration(
                        labelText: 'company'.tr,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: streetNameController,
                      decoration: InputDecoration(
                        labelText: 'street_name'.tr,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'street_is_mandatory'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  SizedBox(
                    width: isLargeScreen(Get.context!) ? 200 : 100,
                    child: TextFormField(
                      controller: houseNumberController,
                      decoration: InputDecoration(
                        labelText: 'house_number'.tr,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'housenumber_is_mandatory'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: cityController,
                      decoration: InputDecoration(
                        labelText: 'city'.tr,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'city_is_mandatory'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  SizedBox(
                    width: isLargeScreen(Get.context!) ? 200 : 100,
                    child: TextFormField(
                      controller: zipController,
                      decoration: InputDecoration(
                        labelText: 'zip'.tr,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'zip_is_mandatory'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
               Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'email'.tr,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'email_name_is_mandatory'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'phone'.tr,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.bottomRight,
                child: CupertinoButton(
                  onPressed: onConfirmTap,
                  color: Get.theme.primaryColor,
                  child: Text('confirm'.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  void onConfirmTap() {
    if (!formKey.currentState!.validate()) return;
    // TODO call enpoint to upadte the privacy policy config
  }
}