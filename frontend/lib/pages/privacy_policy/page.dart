import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/common/components/page_wrapper.dart';


const privacyPolicyRoute = '/privacyPolicy';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) => PageWrapper(
        child: 
    Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 18.0, left: 250.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Privacy Policy'.tr, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 35.0)),
          ],
        ),
      ),
    ),
  );
}