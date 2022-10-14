import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/login/controller.dart';


class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500
            ),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: controller.emailController,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black54),
                      prefixIcon: Icon(Icons.numbers, color: Colors.black45),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Obx(() => TextFormField(
                    controller: controller.passwordController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      labelText: 'Passwort',
                      labelStyle: const TextStyle(color: Colors.black54),
          
                      prefixIcon: const Icon(
                        Icons.password_outlined,
                        color: Colors.black45,
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(),
                      suffixIcon: IconButton(
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
                  const SizedBox(height: 18),
                  SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                        onPressed: controller.login,
                        child: const Text(
                          'Anmelden',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}