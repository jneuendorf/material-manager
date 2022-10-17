import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
      constraints: const BoxConstraints(
        maxWidth: 500,
        minHeight: 800,
      ),
      padding: const EdgeInsetsDirectional.all(10),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    ),
  );

  Widget buildMembershipInfoPage() => buildBaseContainer(
    child: Column(
      children:  [
        TextFormField(
          controller: controller.membershipNumberController,
          decoration: InputDecoration(
            fillColor: Colors.white,
            focusColor: Colors.white,
            labelText: 'membership_number'.tr,
            labelStyle: const TextStyle(color: Colors.black54),
            prefixIcon: const Icon(Icons.account_box),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(),
          ),
        ),
        TextFormField(
          controller: controller.firstNameController,
          decoration: InputDecoration(
            focusColor: Colors.white,
            labelText: 'first_name'.tr,
            labelStyle: const TextStyle(color: Colors.black54),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(),
          ),
        ),
        TextFormField(
          controller: controller.lastNameController,
          decoration: InputDecoration(
            focusColor: Colors.white,
            labelText: 'last_name'.tr,
            labelStyle: const TextStyle(color: Colors.black54),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(),
          ),
        ),
        CupertinoButton(
          onPressed: () {
            controller.pageController.animateToPage(1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          child: Text('next'.tr)
        ),
      ],
    ),
  );

  Widget buildAddressInfoPage() => Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children:  [
      TextFormField(
        controller: controller.streetNameController,
        decoration: InputDecoration(
          focusColor: Colors.white,
          labelText: 'street_name'.tr,
          labelStyle: const TextStyle(color: Colors.black54),
          prefixIcon: const Icon(Icons.account_box),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
        ),
      ),
      TextFormField(
        controller: controller.houseNumberController,
        decoration: InputDecoration(
          focusColor: Colors.white,
          labelText: 'house_number'.tr,
          labelStyle: const TextStyle(color: Colors.black54),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
        ),
      ),
      TextFormField(
        controller: controller.cityController,
        decoration: InputDecoration(
          focusColor: Colors.white,
          labelText: 'city'.tr,
          labelStyle: const TextStyle(color: Colors.black54),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
        ),
      ),
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
      )
    ],
  );

  Widget buildContactInfoPage() => Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children:  [
      TextFormField(
        controller: controller.membershipNumberController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          focusColor: Colors.white,
          labelText: 'membership_number'.tr,
          labelStyle: const TextStyle(color: Colors.black54),
          prefixIcon: const Icon(Icons.account_box),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
        ),
      ),
      TextFormField(
        controller: controller.firstNameController,
        decoration: InputDecoration(
          focusColor: Colors.white,
          labelText: 'first_name'.tr,
          labelStyle: const TextStyle(color: Colors.black54),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
        ),
      ),
      TextFormField(
        controller: controller.lastNameController,
        decoration: InputDecoration(
          focusColor: Colors.white,
          labelText: 'last_name'.tr,
          labelStyle: const TextStyle(color: Colors.black54),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
        ),
      )
    ],
  );

  Widget buildPasswordPage() => Container();
}

