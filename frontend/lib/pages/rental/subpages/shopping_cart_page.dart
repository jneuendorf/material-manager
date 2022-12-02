import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/rental/components/period_selector.dart';
import 'package:frontend/pages/login/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/buttons/base_button.dart';
import 'package:frontend/common/util.dart';


class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  final apiService = Get.find<ApiService>();
  final rentalPageController = Get.find<RentalPageController>();

  late bool loggedIn;

  @override
  void initState() {
    super.initState();

    loggedIn = apiService.isAuthorized;
  }

  @override
  Widget build(BuildContext context) => PageWrapper(
    showPadding: false,
    showBackButton: !isLargeScreen(context),
    pageTitle: !isLargeScreen(context) ? 'shopping_cart'.tr : null,
    child: isLargeScreen(context) ? Row(
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
                      const Icon(Icons.arrow_back_rounded,
                        color: Colors.black,
                      ),
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
                  PeriodSelector(),
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
          PeriodSelector(),
          buildTotal(),
        ],
      ),
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
          Obx(() => Text('€ ${rentalPageController.totalPrice.toStringAsFixed(2)}',
            style: Get.textTheme.subtitle2,
          )),
        ],
      ),
      loggedIn ? Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: BaseButton(
          onPressed: rentalPageController.onCheckoutTap,
          text: 'checkout'.tr,
          color: Colors.black,
        ),
      ) : buildLoginNotice(),
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
        leading: rentalPageController.shoppingCart[index].imageUrls.isNotEmpty
          ? Image.network(baseUrl + rentalPageController.shoppingCart[index].imageUrls.first)
          : const Icon(Icons.image),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rentalPageController.shoppingCart[index].materialType.name,
                  style: Get.textTheme.subtitle2,
                ),
                Text(rentalPageController.getPropertyString(rentalPageController.shoppingCart[index])),
              ],
            ),
            Text('€${rentalPageController.shoppingCart[index].rentalFee.toStringAsFixed(2)}'),
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

  Widget buildLoginNotice() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('login_notice'.tr,
          style: Get.textTheme.headline6!.copyWith(color: Get.theme.primaryColor),
        ),
        const SizedBox(height: 8.0),
        BaseButton(
          onPressed: () async {
            afterLoginRoute = rentalShoppingCartRoute;
            await Get.toNamed(loginRoute);
            afterLoginRoute = rentalRoute;

            setState(() {
              loggedIn = apiService.isAuthorized;
            });
          },
          text: 'login'.tr,
          color: Colors.black,
        ),
      ],
    ),
  );

}
