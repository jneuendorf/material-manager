import 'package:flutter/material.dart';

//import 'package:get/get.dart';


class ExtrasScreen extends StatelessWidget {
  const ExtrasScreen({super.key});

  @override
  Widget build(BuildContext context) => ListView.separated(
    itemCount: children.length,
    separatorBuilder: (BuildContext context, int index) => const Divider(),
    itemBuilder: (BuildContext context, int index) => children[index],
  );

  final List<Widget> children = const [
    
  ];
}