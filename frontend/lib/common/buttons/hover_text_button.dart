import 'package:flutter/material.dart';

import 'package:get/get.dart';


class HoverTextButton extends StatelessWidget {
  final void Function() onTap;
  final String text;
  
  HoverTextButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  final RxBool hovering = false.obs;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => hovering.value = true,
    onExit: (_) => hovering.value = false,
    child: GestureDetector(
      onTap: onTap,
      child: Obx(() => Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: hovering.value 
            ? Get.theme.primaryColor 
            : Get.theme.colorScheme.secondary,
        ),
      )),
    ),
  );
}