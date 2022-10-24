import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/buttons/dav_button.dart';


class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  static final rentalPageController = Get.find<RentalPageController>();

  final RxBool hadError = false.obs;

  @override
  Widget build(BuildContext context) => PageWrapper(
    showPadding: false,
    showBackButton: !kIsWeb,
    pageTitle: !kIsWeb ? 'shopping_cart'.tr : null,
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
                buildShoppingCartList(),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12.0),
                  Text('summary'.tr, style: Get.textTheme.headline6),
                  const Divider(),
                  const Spacer(),
                  buildPeriodDetails(),
                  const Spacer(),
                  buildTotal(),
                ],
              ),
            ),
          ),
        ),
      ],
    ) : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          buildShoppingCartList(),
          buildPeriodDetails(),
          buildTotal(),
        ],
      ),
    ),
  );

  Widget buildPeriodDetails() => Form(
    key: rentalPageController.shoppingCartFormKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('retal_period'.tr.toUpperCase(), 
            style: Get.textTheme.subtitle2,
          ),
        ),
        !kIsWeb ? Row (
          children: [
            Expanded(
              child: buildCustomTextField(
                controller: rentalPageController.rentalStartController, 
                labelText: 'enter_start_date'.tr, 
                validator: rentalPageController.validateDateTime,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: buildCustomTextField(
                controller: rentalPageController.rentalEndController,
                labelText: 'enter_end_date'.tr,
                validator: rentalPageController.validateDateTime,
              ),
            ),
          ],
        ) : Column(
          children: [
            buildCustomTextField(
              controller: rentalPageController.rentalStartController, 
              labelText: 'enter_start_date'.tr, 
              validator: rentalPageController.validateDateTime,
            ),
            const SizedBox(height: 12.0),
            buildCustomTextField(
              controller: rentalPageController.rentalEndController,
              labelText: 'enter_end_date'.tr,
              validator: rentalPageController.validateDateTime,
            ),
          ],
        ), 
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
          child: Text('usage_period'.tr.toUpperCase(), 
            style: Get.textTheme.subtitle2,
          ),
        ),
        !kIsWeb ? Row(
          children: [
            Expanded(
              child: buildCustomTextField(
                controller: rentalPageController.usageStartController,
                labelText: 'enter_start_date'.tr,
                validator: rentalPageController.validateUsageStartDate,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: buildCustomTextField(
                controller: rentalPageController.usageEndController,
                labelText: 'enter_end_date'.tr,
                validator: rentalPageController.validateUsageEndDate,
              ),
            ),
          ],
        ) : Column(
          children: [
            buildCustomTextField(
              controller: rentalPageController.usageStartController,
              labelText: 'enter_start_date'.tr,
              validator: rentalPageController.validateUsageStartDate,
            ),
            const SizedBox(height: 12.0),
            buildCustomTextField(
              controller: rentalPageController.usageEndController,
              labelText: 'enter_end_date'.tr,
              validator: rentalPageController.validateUsageEndDate,
            ),
          ],
        ),
      ],
    ),
  );

  Widget buildTotal() => Column(
    children: [
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
          onPressed: rentalPageController.onCheckoutTap,
          text: 'checkout'.tr,
          color: Colors.black,
        ),
      ),
    ],
  );

  Widget buildShoppingCartList() => Expanded(
    child: Obx(() => rentalPageController.shoppingCart.isNotEmpty ? ListView.separated(
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
    ) : Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.warning_amber),
        const SizedBox(width: 8.0),
        Text('shopping_cart_is_empty'.tr),
      ],
    )),
  );

  Widget buildCustomTextField({required TextEditingController controller, 
  required String labelText, required String? Function(String?)? validator}) {
    controller.addListener(() { 
      if (hadError.value) rentalPageController.shoppingCartFormKey.currentState!.validate();
    });
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        focusColor: Colors.white,
        prefixIcon: const Icon(Icons.calendar_today),
        labelText: labelText,
        enabledBorder: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(),
        errorBorder: const OutlineInputBorder(),
      ),
      onTap: () async => controller.text = (await rentalPageController.pickDate()) ?? '',
      validator: (String? s) {
        String? errorMsg =  validator!(s);
        if (errorMsg != null) {
          hadError.value = true;
        }
        return errorMsg;
      },
    );
  }
}