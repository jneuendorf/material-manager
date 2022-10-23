import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/pages/rental/controller.dart';


class MaterialPreview extends StatelessWidget {
  final MaterialModel item;

  MaterialPreview({Key? key, required this.item}) : super(key: key);

  final RxBool hover = false.obs;

  static final rentalPageController = Get.find<RentalPageController>();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(4.0),
    child: AspectRatio(
      aspectRatio: 1.0,
      child: InkWell(
        onHover: (bool value) => hover.value = value,
        hoverColor: Colors.black,
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
                      child: Image.network(item.imagePath),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${item.equipmentType.description}, ${item.properties.first.value} ${item.properties.first.unit}'),
                          Text('${item.rentalFee} €'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (hover.value || !kIsWeb) Positioned(
              top: 0.0,
              right: 0.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color.fromRGBO(0, 131, 199, 1),
                  padding: const EdgeInsets.symmetric(vertical: kIsWeb ? 10.0 : 6.0),
                ),
                onPressed: () => rentalPageController.shoppingCart.add(item),
                child: const Icon(Icons.add_shopping_cart,
                  size: 30.0,
                  color: Color.fromRGBO(0, 131, 199, 1),
                ),
              ),
            ),
          ],
        )),
      ),
    ),
  );
}