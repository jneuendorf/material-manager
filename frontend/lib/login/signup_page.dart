import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:frontend/login/controller.dart';
import 'package:frontend/common/components/dav_app_bar.dart';
import 'package:frontend/common/components/dav_footer.dart';

class SignupPage extends GetView<LoginController> {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: kIsWeb ? const DavAppBar(loggedIn: false) : null,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: controller.pageController,
                children:  <Widget>[
                  buildMembershipInfoPage(),
                  buildAddressInfoPage(),
                  buildContactInfoPage(),
                  buildPasswordPage(),
                ],
              ),
            ),
            SmoothPageIndicator(
                controller: controller.pageController,  // PageController
                count:  4,
                effect:  WormEffect(
                  dotColor: const Color.fromRGBO(176, 219, 153, 1),
                  activeDotColor: Get.theme.primaryColor,
                ),  // your preferred effect
                onDotClicked: (index){
                  controller.pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                }
            ),
            if (kIsWeb) const Align(
              alignment: Alignment.bottomCenter,
              child: DavFooter(),
            ),
          ],
        ),
      ),
    ),
  );

  Widget buildBaseContainer({Widget? child}) => Center(
    child: Container(
      margin: const EdgeInsets.all(10.0),
      constraints: const BoxConstraints(
        maxWidth: 500,
        maxHeight: 475,
      ),
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(176, 219, 153, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
          padding: const EdgeInsetsDirectional.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: child
      ),
    ),
  );

  Widget buildMembershipInfoPage() => buildBaseContainer(
    child: Column(
      children:  [
        TextFormField(
          controller: controller.membershipNumberController,
          decoration: InputDecoration(
            fillColor: Colors.red,
            focusColor: Colors.white,
            labelText: 'membership_number'.tr,
            labelStyle: const TextStyle(color: Colors.black54),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(),
          ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _validateMembershipNumber,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: controller.firstNameController,
          decoration: InputDecoration(
            focusColor: Colors.white,
            labelText: 'first_name'.tr,
            labelStyle: const TextStyle(color: Colors.black54),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _validateName,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: controller.lastNameController,
          decoration: InputDecoration(
            focusColor: Colors.white,
            labelText: 'last_name'.tr,
            labelStyle: const TextStyle(color: Colors.black54),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _validateName,
        ),
        const SizedBox(height: 16.0),
        CupertinoButton(
            onPressed: () {
              controller.pageController.animateToPage(1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
            child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black54),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Text('next'.tr)
            )
        ),
      ],
    ),
  );

  Widget buildAddressInfoPage() => buildBaseContainer(
      child: Column(
        children:  [
          TextFormField(
            controller: controller.streetNameController,
            decoration: InputDecoration(
              focusColor: Colors.white,
              labelText: 'street_name'.tr,
              labelStyle: const TextStyle(color: Colors.black54),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _validateStreet,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: controller.houseNumberController,
            decoration: InputDecoration(
              focusColor: Colors.white,
              labelText: 'house_number'.tr,
              labelStyle: const TextStyle(color: Colors.black54),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _validateHouseNumber,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: controller.cityController,
            decoration: InputDecoration(
              focusColor: Colors.white,
              labelText: 'city'.tr,
              labelStyle: const TextStyle(color: Colors.black54),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _validateCity,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: controller.zipController,
            decoration: InputDecoration(
              fillColor: Colors.white,
              focusColor: Colors.white,
              labelText: 'zip'.tr,
              labelStyle: const TextStyle(color: Colors.black54),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (!GetUtils.isNumericOnly(value!)) {
                return 'zip_not_valid'.tr;
              } else {
                return null;
              }
            },
          ),
          CupertinoButton(
              onPressed: () {
                controller.pageController.animateToPage(2,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              child: Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black54),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text('next'.tr)
              )
          ),
        ],
      ),
  );

  Widget buildContactInfoPage() => buildBaseContainer(
      child: Column(
        children:  [
          TextFormField(
            controller: controller.signupEmailController,
            decoration: InputDecoration(
              fillColor: Colors.white,
              focusColor: Colors.white,
              labelText: 'email'.tr,
              labelStyle: const TextStyle(color: Colors.black54),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (!GetUtils.isEmail(value!)) {
                return 'email is not valid'.tr;
              } else {
                return null;
              }
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: controller.phoneController,
            decoration: InputDecoration(
              focusColor: Colors.white,
              labelText: 'phone'.tr,
              labelStyle: const TextStyle(color: Colors.black54),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (!GetUtils.isPhoneNumber(value!)) {
                return 'phone_not_valid'.tr;
              } else {
                return null;
              }
            },
          ),
          const SizedBox(height: 16.0),
          CupertinoButton(
              onPressed: () {
                controller.pageController.animateToPage(3,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              child: Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black54),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text('next'.tr)
              )
          ),
        ],
      ),
  );

  Widget buildPasswordPage() => buildBaseContainer(
    child: Column(
      children:  [
        TextFormField(
          controller: controller.signupPasswordController,
          decoration: InputDecoration(
            fillColor: Colors.white,
            focusColor: Colors.white,
            labelText: 'password'.tr,
            labelStyle: const TextStyle(color: Colors.black54),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _validatePassword,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: controller.signupPasswordConfirmController,
          decoration: InputDecoration(
            focusColor: Colors.white,
            labelText: 'confirm_password'.tr,
            labelStyle: const TextStyle(color: Colors.black54),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _validateConfirmPassword,
        ),
        const SizedBox(height: 16.0),
        CupertinoButton(
            onPressed: () {
              controller.pageController.animateToPage(3,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
            child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black54),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Text('signup'.tr)
            )
        ),
      ],
    ),
  );

  //set membership number on valid if lenght is 5
  String? _validateMembershipNumber(String? value) {
    if(value!.isEmpty) {
      return 'membership_num_is_mandatory'.tr;
    }
    final membershipNum = RegExp(r'\d{5}');
    if(!membershipNum.hasMatch(value!)){
      return 'invalid_membership_num'.tr;
    }
    return null;
  }

  // Allows a name with an initial capital letter and any length
  String? _validateName(String? value) {
    if(value!.isEmpty) {
      return 'name_is_mandatory'.tr;
    }
    return null;
  }

  String? _validateStreet(String? value) {
    if(value!.isEmpty) {
      return 'street_is_mandatory'.tr;
    }
    return null;
  }



  String? _validateCity(String? value) {
    if(value!.isEmpty) {
      return 'city_is_mandatory'.tr;
    }
    return null;
  }


  String? _validateHouseNumber(String? value) {
    if(value!.isEmpty) {
      return 'housenumber_is_mandatory'.tr;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if(value!.isEmpty) {
      return 'password_is_mandatory'.tr;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if(value!.isEmpty) {
      return 'password_is_mandatory'.tr;
    }
    var password = controller.signupPasswordController.text;
    if(password != value.toString()){
      return 'passwords_not_equal'.tr;
    }
    return null;
  }

}

