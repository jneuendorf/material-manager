import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/login/controller.dart';
import 'package:frontend/pages/signup/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';


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
              Obx(() => TextFormField(
                controller: controller.emailController,
                cursorColor: controller.error.value == '' ? Colors.black : Colors.red,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'email'.tr,
                  labelStyle: TextStyle(color: controller.error.value == '' ? Colors.black54 : Colors.red),
                  prefixIcon: Icon(Icons.numbers, color: controller.error.value == '' ? Colors.black45 : Colors.red),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(),
                ),
                onFieldSubmitted: (value) {
                  controller.login();
                },
              )),
              const SizedBox(height: 18),

              // PASSWORD
              Obx(() => TextFormField(
                controller: controller.passwordController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  labelText: 'password'.tr,
                  labelStyle: TextStyle(color: controller.error.value == '' ? Colors.black54 : Colors.red),
                  prefixIcon: Icon(
                    Icons.password_outlined,
                    color: controller.error.value == '' ? Colors.black45 : Colors.red
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

              // ERROR MESSAGE
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Obx(() => Text(
                  controller.error.value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                )),
              ),

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

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: controller.login,
                  child: Text(
                    'login'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
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
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () => Get.toNamed(signupRoute),
              child: Text(
                'signup'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
