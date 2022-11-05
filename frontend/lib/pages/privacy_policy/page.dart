import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/common/components/page_wrapper.dart';


const privacyPolicyRoute = '/privacyPolicy';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) => PageWrapper(
    loggedIn: false,
    child: Text('privacy_policy'.tr),
  );
}