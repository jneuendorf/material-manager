import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';


class ImageBuilder extends StatelessWidget {
  final String url;

  ImageBuilder({super.key, required this.url});

  final RxBool error = false.obs;

  @override
  Widget build(BuildContext context) => Obx(() => Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      image: !kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST') ? DecorationImage(
        image: NetworkImage(url),
      ): null,
    ),
    child: error.value ? const Center(child: Icon(Icons.error)) : null,
  ));
}