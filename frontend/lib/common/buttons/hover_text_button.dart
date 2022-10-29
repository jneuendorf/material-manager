import 'package:flutter/material.dart';

import 'package:get/get.dart';


class HoverTextButton extends StatelessWidget {
  final void Function() onTap;
  final String text;
  final Color color;
  final Color hoverColor;
  final FontWeight? fontWeight;
  
  HoverTextButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.color,
    required this.hoverColor,
    this.fontWeight,
  }) : super(key: key);

  final RxBool hovering = false.obs;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => hovering.value = true,
    onExit: (_) => hovering.value = false,
    child: GestureDetector(
      onTap: onTap,
      child: Obx(() => Text(text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: fontWeight,
          color: hovering.value 
            ? hoverColor 
            : color,
        ),
      )),
    ),
  );
}