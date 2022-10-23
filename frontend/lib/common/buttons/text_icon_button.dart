import 'package:flutter/material.dart';


class TextIconButton extends StatelessWidget {
  final void Function()? onTap;
  final IconData iconData;
  final String text;
  final Color? color;

  const TextIconButton({
    Key? key,
    required this.onTap,
    required this.iconData,
    required this.text,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconData, color: color),
        const SizedBox(width: 4.0),
        Text(text, style: TextStyle(color: color)),
      ],
    ),
  );
}