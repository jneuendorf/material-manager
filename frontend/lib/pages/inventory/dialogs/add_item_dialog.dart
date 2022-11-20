import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/extensions/material/model.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/inventory/controller.dart';
import 'package:frontend/common/components/base_future_dialog.dart';
import 'package:frontend/common/buttons/text_icon_button.dart';


class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final materialController = Get.find<InventoryPageController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxBool loading = false.obs;
  final RxList properties = [].obs;
  late  RxInt counter = 1.obs;
  final RxList<MapEntry<String?, List<SerialNumber>>> bulkValues = <MapEntry<String?, List<SerialNumber>>>[].obs;

  TextEditingController descriptionController = TextEditingController();
  TextEditingController rentalFeeController = TextEditingController();
  TextEditingController maxLifeExpectancyController = TextEditingController();
  TextEditingController maxServiceDurationController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  TextEditingController nextInspectionController = TextEditingController();
  TextEditingController propertyNameController = TextEditingController();
  TextEditingController propertyValueController = TextEditingController();
  TextEditingController propertyUnitController = TextEditingController();
  TextEditingController purchaseDateController = TextEditingController();
  TextEditingController merchantController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController invoiceNumberController = TextEditingController();
  TextEditingController productionDateController = TextEditingController();
  TextEditingController suggestedRetailPriceController = TextEditingController();
  TextEditingController serialNumberController = TextEditingController();
  TextEditingController inventoryNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) => BaseFutureDialog(
    loading: loading,
    child: Form(
      key: formKey,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('add_item'.tr,
                  style: Get.textTheme.headline6,
                ),
              ),
              IconButton(
                splashRadius: 18.0,
                onPressed: Get.back,
                icon: const Icon(CupertinoIcons.xmark),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'description'.tr,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: TextFormField(
                    controller: rentalFeeController,
                    decoration: InputDecoration(
                      labelText: 'rental_fee'.tr,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 180,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 50.0),
                                child: TextFormField(
                                  controller: maxLifeExpectancyController,
                                  decoration: InputDecoration(
                                    labelText: 'max_life_expectancy'.tr,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 50.0),
                                child: TextFormField(
                                  controller: maxServiceDurationController,
                                  decoration: InputDecoration(
                                    labelText: 'max_service_duration'.tr,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: instructionsController,
                          decoration: InputDecoration(
                            labelText: 'instructions'.tr,
                          ),
                        ),
                        TextFormField(
                          controller: nextInspectionController,
                          decoration: InputDecoration(
                            labelText: 'next_inspection'.tr,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Obx(() => ListView.builder(
                              shrinkWrap: true,
                              itemCount: properties.length,
                              itemBuilder: (context, index) =>  Card(
                                elevation: 5,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: TextFormField(
                                          controller: propertyNameController,
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            labelText: 'name'.tr,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: TextFormField(
                                          controller: propertyValueController,
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            labelText: 'value'.tr,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: propertyUnitController,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          labelText: 'unit'.tr,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      tooltip: 'remove'.tr,
                                      onPressed: () => properties.remove(properties[index]),
                                      iconSize: 15.0,
                                      splashRadius: 18.0,
                                      icon: const Icon(CupertinoIcons.xmark),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextIconButton(
                          onTap: () {
                            properties.add(1);
                          },
                          iconData: Icons.add,
                          text: 'add_property'.tr,
                          color: Get.theme.colorScheme.onSecondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 50.0),
                        child: TextFormField(
                          controller: purchaseDateController,
                          decoration: InputDecoration(
                            labelText: 'purchase_date'.tr,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 50.0),
                        child: TextFormField(
                          controller: merchantController,
                          decoration: InputDecoration(
                            labelText: 'merchant'.tr,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: purchasePriceController,
                        decoration: InputDecoration(
                          labelText: 'purchase_price'.tr,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: invoiceNumberController,
                        decoration: InputDecoration(
                          labelText: 'invoice_number'.tr,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: productionDateController,
                        decoration: InputDecoration(
                          labelText: 'production_date'.tr,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: suggestedRetailPriceController,
                        decoration: InputDecoration(
                          labelText: 'suggested_retail_price'.tr,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
              shrinkWrap: true,
              itemCount: bulkValues.length,
              itemBuilder: (context, index) =>  Row(
                children: [
                  IconButton(
                    onPressed: () {
                      bulkValues.removeAt(index);
                    },
                    splashRadius: 18.0,
                    icon: const Icon(CupertinoIcons.minus_circle_fill,
                      color: Colors.red,
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 5,
                      child: TextFormField(
                        controller: serialNumberController,
                        onFieldSubmitted: (String value) {
                          if (value.isEmpty) return;

                          // split string at ',' -> subLists will be contained in parts
                          List<String> parts = value.split(',');

                          final List<SerialNumber> numbers = [];

                          for (int i = 0; i < parts.length; i++) {
                            // remove leading or trailing whitespaces
                            parts[i] = parts[i].trim();

                            numbers.add(SerialNumber(
                              serialNumber: value,
                              manufacturer: merchantController.text,
                              productionDate: DateTime.parse(productionDateController.text), // TODO get actual production Date
                            ));
                          }

                          bulkValues[index].value.addAll(numbers);

                          print('Done with length: ${numbers.length}');
                        },
                        decoration: InputDecoration(
                          labelText: 'serial_number'.tr,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 5,
                      child: TextFormField(
                        controller: inventoryNumberController,
                        decoration: InputDecoration(
                          labelText: 'inventory_number'.tr,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
          ),
          TextIconButton(
            onTap: () => bulkValues.add(const MapEntry(null, [])),
            iconData: Icons.add,
            text: 'add_item'.tr,
            color: Get.theme.colorScheme.onSecondary,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: CupertinoButton(
              onPressed: () {},
              color: Get.theme.primaryColor,
              child: Text('add'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
