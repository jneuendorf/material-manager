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
            ),
            const SizedBox(height: 18),
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
                  tooltip: 'show_password'.tr,
                  icon: Icon(
                    controller.hideChars.value
                        ? CupertinoIcons.eye_fill
                        : CupertinoIcons.eye_slash_fill,
                    color: Colors.black,
                  ),
                  onPressed: controller.toggleHideChars,
                ),
              ),
              obscureText: controller.hideChars.value,
            )),
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
                Text('remember_me'.tr,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.grey.shade700,
                ),
                ),
              ],
            ),
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