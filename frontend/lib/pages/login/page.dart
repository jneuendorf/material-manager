import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/login/controller.dart';
import 'package:frontend/pages/signup/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/buttons/dav_button.dart';


class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PageWrapper(
    loggedIn: false,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: controller.constraints,
          child: Column(
            children: [
              // EMAIL
              TextFormField(
                controller: controller.emailController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'email'.tr,
                  labelStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: const Icon(Icons.numbers, color: Colors.black45),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(),
                ),
                onFieldSubmitted: (value) {
                  controller.login();
                },
              ),
              const SizedBox(height: 18),

              // PASSWORD
              Obx(() => TextFormField(
                controller: controller.passwordController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  labelText: 'password'.tr,
                  labelStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: const Icon(
                    Icons.password_outlined,
                    color: Colors.black45,
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    tooltip: (controller.hideChars.value ? 'show_password': 'hide_password').tr,
                    icon: Icon(
                      controller.hideChars.value
                          ? CupertinoIcons.eye_fill
                          : CupertinoIcons.eye_slash_fill,
                      color: Colors.black,
                    ),
                    onPressed: controller.toggleHideChars,
                  ),
                ),
                onFieldSubmitted: (value) {
                  controller.login();
                },
                obscureText: controller.hideChars.value,
              )),

              // REMEMBER ME
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Obx(() => Checkbox(
                      activeColor: Get.theme.primaryColor,
                      shape: const CircleBorder(),
                      value: controller.rememberMe.value,
                      onChanged: controller.rememberMe,
                    )),
                  ),
                  Text(
                    'remember_me'.tr,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),

              DavButton(
                text: 'login'.tr,
                onPressed: controller.login,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 18.0),
          child: Divider(),
        ),

        // SIGNUP BUTTON
        ConstrainedBox(
          constraints: controller.constraints,
          child: DavButton(
            onPressed: () => Get.toNamed(signupRoute),
            text: 'signup'.tr,
          ),
        ),
      ],
    ),
  );
}
