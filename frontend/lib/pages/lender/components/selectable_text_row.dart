import 'package:flutter/material.dart';


class SelectableTextRow extends StatelessWidget {
  final String title; 
  final String value;

  const SelectableTextRow({
    super.key, 
    required this.title, 
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text('$title : ',
        style: const TextStyle(color: Colors.black45),
      ),
      SelectableText(value),
    ],
  );
}

