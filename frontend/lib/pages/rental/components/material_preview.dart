import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/common/util.dart';


class MaterialPreview extends StatelessWidget {
  final MaterialModel item;

  MaterialPreview({Key? key, required this.item}) : super(key: key);

  final rentalPageController = Get.find<RentalPageController>();

  final RxBool hover = false.obs;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(4.0),
    child: AspectRatio(
      aspectRatio: 1.0,
      child: MouseRegion(
        onEnter: (_) => hover.value = true,
        onExit: (_) => hover.value = false,
        child: Obx(() => Stack(
          children: [
            Card(
              color: Colors.white,
              elevation: 10.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Column(
                  children: [
                    Expanded(
                      child: item.imageUrls.isNotEmpty
                        ? Image.network(baseUrl + item.imageUrls.first)
                        : Center(child: Text('no_image_found'.tr)),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${item.materialType.name}, ${rentalPageController.getPropertyString(item)}'),
                          Text('${item.rentalFee.toStringAsFixed(2)} €'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (hover.value || !isLargeScreen(context)) Positioned(
              top: 0.0,
              right: 0.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Get.theme.colorScheme.onSecondary,
                  padding: EdgeInsets.symmetric(
                    vertical: isLargeScreen(context) ? 10.0 : 6.0,
                  ),
                ),
                onPressed: () {
                  if (rentalPageController.rentalPeriod.value != null) {
                    rentalPageController.shoppingCart.add(item);
                  } else {
                    Get.snackbar('error'.tr, 'missing_rental_period'.tr);
                  }
                },
                child: Obx(() => rentalPageController.shoppingCart.contains(item)
                    ? const Icon(Icons.check)
                    : Icon(Icons.add_shopping_cart,
                      size: 30.0,
                      color: Get.theme.colorScheme.onSecondary,
                    ),
                ),
              ),
            ),
          ],
        )),
      ),
    ),
  );
}
