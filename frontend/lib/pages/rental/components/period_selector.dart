import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:frontend/pages/rental/components/custom_text_field.dart';
import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/common/util.dart';


class PeriodSelector extends StatelessWidget {
  PeriodSelector({Key? key}) : super(key: key);

  final rentalPageController = Get.find<RentalPageController>();

  final RxBool hadError = false.obs;
  final DateFormat dateFormat = DateFormat('dd.MM.yyyy');

  @override
  Widget build(BuildContext context) {
    return Form(
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
          ),
        ],
      ),
    );
  }
}
