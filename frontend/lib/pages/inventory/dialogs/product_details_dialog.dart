import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/material/model.dart';


class ProductDetailsDialog extends StatelessWidget {
  final MaterialModel item;
  
  const ProductDetailsDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('product_details'.tr, 
                  style: Get.textTheme.headline6,
                ),
              ),
              IconButton(
                splashRadius: 20,
                onPressed: Get.back,
                icon: const Icon(CupertinoIcons.xmark),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          // TODO implement dialog
        ],
      ),
    ),
  );
}