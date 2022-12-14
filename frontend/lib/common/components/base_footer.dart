import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/common/buttons/hover_text_button.dart';
import 'package:frontend/pages/imprint/page.dart';
import 'package:frontend/pages/privacy_policy/page.dart';


class BaseFooter extends StatelessWidget {
  const BaseFooter({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 10.0,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HoverTextButton(
                text: 'imprint'.tr,
                color: Get.theme.colorScheme.secondary,
                hoverColor: Get.theme.primaryColor,
                onTap: () => Get.toNamed(imprintRoute),
              ),
              HoverTextButton(
                text: 'privacy_policy'.tr,
                color: Get.theme.colorScheme.secondary,
                hoverColor: Get.theme.primaryColor,
                onTap: () => Get.toNamed(privacyPolicyRoute),
              ),
            ],
          ),
        ),
        Text('Copyright 2022',
          style: TextStyle(
            color: Get.theme.colorScheme.secondary,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              HoverTextButton(
                text: 'links'.tr,
                color: Get.theme.colorScheme.secondary,
                hoverColor: Get.theme.primaryColor,
                onTap: () {},
              ),
              HoverTextButton(
                text: 'privacy_policy'.tr,
                color: Get.theme.colorScheme.secondary,
                hoverColor: Get.theme.primaryColor,
                onTap: () => Get.toNamed(privacyPolicyRoute),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
