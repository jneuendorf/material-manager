import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:frontend/pages/signup/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';


class SignupPage extends GetView<SignupController> {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PageWrapper(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: PageView(
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              buildMembershipInfoPage(),
              buildAddressInfoPage(),
              buildContactInfoPage(),
              buildPasswordPage(),
            ],
          ),
        ),
        SmoothPageIndicator(
          controller: controller.pageController,
          count: 4,
          effect: WormEffect(
            dotColor: Get.theme.colorScheme.onSurface,
            activeDotColor: Get.theme.primaryColor,
          ),
          onDotClicked: (int index) => controller.pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          )
        ),
      ],
    ),
  );

  Widget buildBaseContainer({required Widget child, required GlobalKey<FormState> formKey}) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          padding: const EdgeInsetsDirectional.all(16),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.onSurface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsetsDirectional.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Form(
              key: formKey,
              child: child,
            )
          ),
        ),
      ],
    ),
  );

  Widget buildMembershipInfoPage() => buildBaseContainer(
    formKey: controller.membershipKey,
    child: Column(
      children: [
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
          validator: controller.validateName,
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
          validator: controller.validateName,
        ),
        const SizedBox(height: 16.0),
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
            validator: controller.validateMembershipNumber,
        ),
        buildButton(0, controller.membershipKey),
      ],
    ),
  );

  Widget buildAddressInfoPage() => buildBaseContainer(
    formKey: controller.addressKey,
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
          validator: controller.validateStreet,
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
          validator: controller.validateHouseNumber,
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
          validator: controller.validateCity,
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
        buildButton(1, controller.addressKey),
      ],
    ),
  );

  Widget buildContactInfoPage() => buildBaseContainer(
    formKey: controller.contactKey,
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
        buildButton(2, controller.contactKey),
      ],
    ),
  );

  Widget buildPasswordPage() => buildBaseContainer(
    formKey: controller.passwordKey,
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
          validator: controller.validatePassword,
          obscureText: true,
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
          validator: controller.validateConfirmPassword,
          obscureText: true,
        ),
        buildButton(3, controller.passwordKey),
      ],
    ),
  );

  /// Builds the button for the form.
  /// Validates the form by the given [key], when button is pressed.
  Widget buildButton(int currentIndex, GlobalKey<FormState> key) => CupertinoButton(
    padding: const EdgeInsets.only(top: 16.0),
    onPressed: () {
      if (key.currentState!.validate()) {
        currentIndex != 3
          ? controller.pageController.animateToPage(currentIndex + 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut)
          : controller.signup();
      }
    },
    child: Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black54),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(currentIndex != 3 ? 'next'.tr : 'signup'.tr)
    ),
  );

}

