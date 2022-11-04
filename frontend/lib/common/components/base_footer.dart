import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/common/buttons/hover_text_button.dart';


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
                text: 'Deutscher Alpenverein',
                color: Get.theme.colorScheme.secondary,
                hoverColor: Get.theme.primaryColor,
                onTap: () {},
              ),
              HoverTextButton(
                text: 'imprint'.tr,
                color: Get.theme.colorScheme.secondary,
                hoverColor: Get.theme.primaryColor,
                onTap: () {},
              ),
              HoverTextButton(
                text: 'privacy_policy'.tr,
                color: Get.theme.colorScheme.secondary,
                hoverColor: Get.theme.primaryColor,
                onTap: () {},
              ),
            ],
          ),
        ),
        Text(MediaQuery.of(context).size.width < 450
          ? 'Copyright 2022'
          : 'Copyright 2022 Deutscher Alpenverein',
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
                text: 'other'.tr,
                color: Get.theme.colorScheme.secondary,
                hoverColor: Get.theme.primaryColor,
                onTap: () {},
              ),
              HoverTextButton(
                text: 'privacy_policy'.tr,
                color: Get.theme.colorScheme.secondary,
                hoverColor: Get.theme.primaryColor,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
