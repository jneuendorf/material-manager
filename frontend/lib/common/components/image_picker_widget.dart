import 'package:flutter/material.dart';

import 'package:get/get.dart'; 
import 'package:cross_file/cross_file.dart';

import 'package:frontend/common/util.dart';


class ImagePickerWidget extends StatelessWidget {
  final void Function(List<XFile>) onPicked;

  const ImagePickerWidget({super.key, required this.onPicked});

  @override
  Widget build(BuildContext context) => Container(
    width: 150,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: Get.theme.colorScheme.onSecondary),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(Icons.image),
          Text('add_image'.tr),
          FloatingActionButton(
            onPressed: () async {
              List<XFile> images = (await pickImages()) ?? [];

              if (images.isNotEmpty) {
                onPicked(images);
              }
            },
            backgroundColor: Get.theme.colorScheme.onSecondary,
            foregroundColor: Colors.white,
            elevation: 10,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    ),
  );
}