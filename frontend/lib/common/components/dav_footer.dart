import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/common/buttons/hover_text_button.dart';


class DavFooter extends StatelessWidget {
  const DavFooter({super.key});

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
                onTap: () {},
              ),
              HoverTextButton(
                text: 'imprint'.tr, 
                onTap: () {},
              ),
              HoverTextButton(
                text: 'privacy_policy'.tr, 
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
                onTap: () {},
              ),
              HoverTextButton(
                text: 'other'.tr, 
                onTap: () {},
              ),
              HoverTextButton(
                text: 'privacy_policy'.tr, 
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    ),
  );
}