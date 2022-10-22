import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/buttons/dav_button.dart';


class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  static final rentalPageController = Get.find<RentalPageController>();

  @override
  Widget build(BuildContext context) => PageWrapper(
    showPadding: false,
    child: kIsWeb ? Row(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('shopping_cart'.tr, 
                  style: Get.textTheme.headline6!.copyWith(fontSize: 30),
                ),
                const Divider(),
                Expanded(
                  child: Obx(() => ListView.separated(
                    itemCount: rentalPageController.shoppingCart.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) => ListTile(
                      tileColor: Colors.transparent,
                      style: ListTileStyle.list,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                      onTap: () {},
                      leading: Image.network(rentalPageController.shoppingCart[index].imagePath),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(rentalPageController.shoppingCart[index].equipmentType.description, 
                                style: Get.textTheme.subtitle2,
                              ),
                              Text('${rentalPageController.shoppingCart[index].properties.first.value} ${rentalPageController.shoppingCart[index].properties.first.unit}'),
                            ],
                          ),
                          Text('€${rentalPageController.shoppingCart[index].rentalFee}'),
                        ],
                      ),
                      trailing: IconButton(
                        padding: EdgeInsets.zero,
                        tooltip: 'remove'.tr,
                        onPressed: () => rentalPageController.shoppingCart.removeAt(index),
                        iconSize: 15.0,
                        splashRadius: 18.0,
                        icon: const Icon(CupertinoIcons.xmark),
                      ),
                    ),
                  )),
                ),
                TextButton(
                  onPressed: Get.back,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back_rounded, color: Colors.black),
                      const SizedBox(width: 8.0),
                      Text('back_to_selection'.tr,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Get.theme.colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: rentalPageController.shoppingCartFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12.0),
                    Text('summary'.tr, style: Get.textTheme.headline6),
                    const Divider(),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('retal_period'.tr.toUpperCase(), 
                        style: Get.textTheme.subtitle2,
                      ),
                    ),
                    TextFormField(
                      controller: rentalPageController.rentalStartController,
                      readOnly: true,
                      decoration: InputDecoration(
                        focusColor: Colors.white,
                        prefixIcon: const Icon(Icons.calendar_today),
                        labelText: 'enter_start_date'.tr,
                        enabledBorder: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(),
                      ),
                      onTap: () async => rentalPageController.rentalStartController.text = 
                        (await rentalPageController.pickDate()) ?? '',
                      validator: rentalPageController.validateDateTime,
                    ),
                    const SizedBox(height: 12.0),
                    TextFormField(
                      controller: rentalPageController.rentalEndController,
                      readOnly: true,
                      decoration: InputDecoration(
                        focusColor: Colors.white,
                        prefixIcon: const Icon(Icons.calendar_today),
                        labelText: 'enter_end_date'.tr,
                        enabledBorder: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(),
                      ),
                      onTap: () async => rentalPageController.rentalEndController.text = 
                        (await rentalPageController.pickDate()) ?? '',
                      validator: rentalPageController.validateDateTime,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
                      child: Text('usage_period'.tr.toUpperCase(), 
                        style: Get.textTheme.subtitle2,
                      ),
                    ),
                    TextFormField(
                      controller: rentalPageController.usageStartController,
                      readOnly: true,
                      decoration: InputDecoration(
                        focusColor: Colors.white,
                        prefixIcon: const Icon(Icons.calendar_today),
                        labelText: 'enter_start_date'.tr,
                        enabledBorder: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(),
                      ),
                      onTap: () async => rentalPageController.rentalStartController.text = 
                        (await rentalPageController.pickDate()) ?? '',
                      validator: rentalPageController.validateDateTime,
                    ),
                    const SizedBox(height: 12.0),
                    TextFormField(
                      controller: rentalPageController.usageEndController,
                      readOnly: true,
                      decoration: InputDecoration(
                        focusColor: Colors.white,
                        prefixIcon: const Icon(Icons.calendar_today),
                        labelText: 'enter_end_date'.tr,
                        enabledBorder: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(),
                      ),
                      onTap: () async => rentalPageController.rentalEndController.text = 
                        (await rentalPageController.pickDate()) ?? '',
                      validator: rentalPageController.validateDateTime,
                    ),
                    const Spacer(),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('total_price'.tr.toUpperCase(),
                          style: Get.textTheme.subtitle2,
                        ),
                        Obx(() => Text('€ ${rentalPageController.totalPrice}',
                          style: Get.textTheme.subtitle2,
                        )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: DavButton(
                        onPressed: () => rentalPageController.shoppingCartFormKey.currentState!.validate(),
                        text: 'checkout'.tr,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ) : const Center(child: Text('App View not implemented')),
  );
}