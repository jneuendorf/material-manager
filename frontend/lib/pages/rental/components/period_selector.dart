import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/common/util.dart';


class PeriodSelector extends StatelessWidget {
  PeriodSelector({Key? key,required this.small}) : super(key: key);

  final rentalPageController = Get.find<RentalPageController>();
  final RxBool hadError = false.obs;
  final DateFormat dateFormat = DateFormat('dd.MM.yyyy');
  final bool small;
  final GlobalKey<FormState> shoppingCartFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: shoppingCartFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('rental_period'.tr.toUpperCase(),
              style: Get.textTheme.subtitle2,
            ),
          ),
          !isLargeScreen(context) || small ? Row (
            children: [
              Expanded(
                child: buildCustomTextField(
                  controller: rentalPageController.rentalStartController,
                  labelText: 'enter_start_date'.tr,
                  validator: rentalPageController.validateDateTime,
                  onValidChanged: (String s) {
                    if(rentalPageController.rentalEndController.value.text != '') {
                      rentalPageController.rentalPeriod.value = RentalPeriod(startDate: dateFormat.parse(s), endDate: dateFormat.parse(rentalPageController.rentalEndController.value.text));
                    }
                    rentalPageController.usageStartController.value.text = s;
                  },
                  hadError: hadError,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: buildCustomTextField(
                  controller: rentalPageController.rentalEndController,
                  labelText: 'enter_end_date'.tr,
                  validator: rentalPageController.validateDateTime,
                  onValidChanged: (String s) {
                    if(rentalPageController.rentalStartController.value.text != '') {
                      rentalPageController.rentalPeriod.value = RentalPeriod(startDate: dateFormat.parse(rentalPageController.rentalStartController.value.text), endDate: dateFormat.parse(s));
                    }
                    rentalPageController.usageEndController.value.text = s;
                  },
                  hadError: hadError,
                ),
              ),
            ],
          ) : Column(
            children: [
              buildCustomTextField(
                controller: rentalPageController.rentalStartController,
                labelText: 'enter_start_date'.tr,
                validator: rentalPageController.validateDateTime,
                onValidChanged: (String s) {
                  if(rentalPageController.rentalEndController.value.text != '') {
                    rentalPageController.rentalPeriod.value = RentalPeriod(startDate: dateFormat.parse(s), endDate: dateFormat.parse(rentalPageController.rentalEndController.value.text));
                  }
                  rentalPageController.usageStartController.value.text = s;
                },
                hadError: hadError,
              ),
              const SizedBox(height: 12.0),
              buildCustomTextField(
                controller: rentalPageController.rentalEndController,
                labelText: 'enter_end_date'.tr,
                validator: rentalPageController.validateDateTime,
                onValidChanged: (String s) {
                  if(rentalPageController.rentalStartController.value.text != '') {
                    rentalPageController.rentalPeriod.value = RentalPeriod(startDate: dateFormat.parse(rentalPageController.rentalStartController.value.text), endDate: dateFormat.parse(s));
                  }
                  rentalPageController.usageEndController.value.text = s;
                },
                hadError: hadError,
              ),
            ],
          ),
           !small ? ExpansionTile(
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
                      hadError: hadError,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: buildCustomTextField(
                      controller: rentalPageController.usageEndController,
                      labelText: 'enter_end_date'.tr,
                      validator: rentalPageController.validateUsageEndDate,
                      hadError: hadError,
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
                    hadError: hadError,
                  ),
                  const SizedBox(height: 12.0),
                  buildCustomTextField(
                    controller: rentalPageController.usageEndController,
                    labelText: 'enter_end_date'.tr,
                    validator: rentalPageController.validateUsageEndDate,
                    hadError: hadError,
                  ),
                ],
              ),
            ],
          ): Container(),
        ],
      ),
    );
  }
  /// Builds a [TextFormField] with the given [controller], [labelText]
  /// and [validator].
  /// The [onValidChanged] callback is called when the [TextFormField] has been
  /// changed and validated by the [validator].
  Widget buildCustomTextField({
    required Rx<TextEditingController> controller,
    required String labelText,
    required String? Function(String?)? validator,
    void Function(String)? onValidChanged,
    required RxBool hadError,
  }) {
    controller.value.addListener(() {
      if (hadError.value) shoppingCartFormKey.currentState!.validate();
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
