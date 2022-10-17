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
            if (kIsWeb) const Spacer(),
            ConstrainedBox(
              constraints: controller.constraints,
              child: Column(
                children: [],
              ),
            ),
            if (kIsWeb) const Spacer(),
            if (kIsWeb) const Align(
              alignment: Alignment.bottomCenter,
              child: DavFooter(),
            ),
          ],
        ),
      ),
    ),
  );
}