import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/util.dart';

import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/login/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';
import 'package:frontend/common/buttons/base_button.dart';


class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  final apiService = Get.find<ApiService>();
  final rentalPageController = Get.find<RentalPageController>();

  late bool loggedIn;
  final RxBool hadError = false.obs;

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
          child: Text('rental_period'.tr.toUpperCase(),
            style: Get.textTheme.subtitle2,
          ),
        ),
        !isLargeScreen(context) ? Row (
          children: [
            Expanded(
              child: buildCustomTextField(
                controller: rentalPageController.rentalStartController,
                labelText: 'enter_start_date'.tr,
                validator: rentalPageController.validateDateTime,
                onValidChanged: (String s) => rentalPageController.usageStartController.value.text = s,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: buildCustomTextField(
                controller: rentalPageController.rentalEndController,
                labelText: 'enter_end_date'.tr,
                validator: rentalPageController.validateDateTime,
                onValidChanged: (String s) => rentalPageController.usageEndController.value.text = s,
              ),
            ),
          ],
        ) : Column(
          children: [
            buildCustomTextField(
              controller: rentalPageController.rentalStartController,
              labelText: 'enter_start_date'.tr,
              validator: rentalPageController.validateDateTime,
              onValidChanged: (String s) => rentalPageController.usageStartController.value.text = s,
            ),
            const SizedBox(height: 12.0),
            buildCustomTextField(
              controller: rentalPageController.rentalEndController,
              labelText: 'enter_end_date'.tr,
              validator: rentalPageController.validateDateTime,
              onValidChanged: (String s) => rentalPageController.usageEndController.value.text = s,
            ),
          ],
        ),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text('usage_period'.tr.toUpperCase(),
            style: Get.textTheme.subtitle2,
          ),
          children: [
            const SizedBox(height: 8.0),
            !isLargeScreen(context) ? Row(
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
              mainAxisSize: MainAxisSize.min,
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
        leading: Image.network(baseUrl + rentalPageController.shoppingCart[index].imageUrls.first),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rentalPageController.shoppingCart[index].materialType.name,
                  style: Get.textTheme.subtitle2,
                ),
                Text('${rentalPageController.shoppingCart[index].properties.first.value} ${rentalPageController.shoppingCart[index].properties.first.unit}'),
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

  /// Builds a [TextFormField] with the given [controller], [labelText] 
  /// and [validator].
  /// The [onValidChanged] callback is called when the [TextFormField] has been 
  /// changed and validated by the [validator]. 
  Widget buildCustomTextField({
    required Rx<TextEditingController> controller, 
    required String labelText, 
    required String? Function(String?)? validator,  
    void Function(String)? onValidChanged,
  }) {
    controller.value.addListener(() {
      if (hadError.value) rentalPageController.shoppingCartFormKey.currentState!.validate();
    });

    return Obx(() => TextFormField(
      controller: controller.value,
      readOnly: true,
      decoration: InputDecoration(
        focusColor: Colors.white,
        prefixIcon: const Icon(Icons.calendar_today),
        labelText: labelText,
        enabledBorder: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(),
        errorBorder: const OutlineInputBorder(),
      ),
      onTap: () async {
        controller.value.text = (await rentalPageController.pickDate()) ?? '';

        if (validator!(controller.value.text) != null || onValidChanged == null) return; 

        onValidChanged(controller.value.text);
      },
      validator: (String? s) {
        String? errorMsg =  validator!(s);
        if (errorMsg != null) {
          hadError.value = true;
        }
        return errorMsg;
      },
    ));
  }
}
