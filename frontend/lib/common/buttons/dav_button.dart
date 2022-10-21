import 'package:flutter/material.dart';


class DavButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed; 
  final Color? color;

  const DavButton({
    super.key, 
    required this.onPressed,
    required this.text, 
    this.color,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 60.0,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(primary: color),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    ),
  );
}