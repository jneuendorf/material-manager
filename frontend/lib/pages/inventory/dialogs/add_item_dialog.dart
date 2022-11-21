import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/material/model.dart';
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
  final RxList<NonFinalMapEntry<String?, List<SerialNumber>>> bulkValues = <NonFinalMapEntry<String?, List<SerialNumber>>>[].obs;
  final RxList<Property> properties = <Property>[].obs;

  TextEditingController descriptionController = TextEditingController();
  TextEditingController rentalFeeController = TextEditingController();
  TextEditingController maxLifeExpectancyController = TextEditingController();
  TextEditingController maxServiceDurationController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  TextEditingController nextInspectionController = TextEditingController();
  TextEditingController purchaseDateController = TextEditingController();
  TextEditingController merchantController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController invoiceNumberController = TextEditingController();
  TextEditingController suggestedRetailPriceController = TextEditingController();

  final List<TextEditingController> propertyNameController = <TextEditingController>[];
  final List<TextEditingController> propertyValueController = <TextEditingController>[];
  final List<TextEditingController> propertyUnitController = <TextEditingController>[];

  final List<TextEditingController> serialNumberControllers = <TextEditingController>[];
  final List<TextEditingController> productionDateControllers = <TextEditingController>[];
  final List<TextEditingController> inventoryNumberControllers = <TextEditingController>[];

  @override
  void initState() {
    super.initState();

    bulkValues.listen((lst) {
      if (serialNumberControllers.length < lst.length) {
        serialNumberControllers.add(TextEditingController());
        productionDateControllers.add(TextEditingController());
        inventoryNumberControllers.add(TextEditingController());
      }

    });
    properties.listen((lst) {
      if (propertyNameController.length < lst.length) {
        propertyNameController.add(TextEditingController());
        propertyUnitController.add(TextEditingController());
        propertyValueController.add(TextEditingController());
      }
    });
  }

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
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
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
                                padding: const EdgeInsets.only(right: 15.0),
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
                                padding: const EdgeInsets.only(right: 10.0),
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
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: TextFormField(
                            controller: instructionsController,
                            decoration: InputDecoration(
                              labelText: 'instructions'.tr,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: TextFormField(
                            controller: nextInspectionController,
                            decoration: InputDecoration(
                              labelText: 'next_inspection'.tr,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Obx(() => ListView.separated(
                            separatorBuilder: (context, index) => const SizedBox(height: 10.0),
                              shrinkWrap: true,
                              itemCount: properties.length,
                              itemBuilder: (context, index) =>  Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: TextFormField(
                                        onFieldSubmitted: (value) => properties[index].name = value.trim(),
                                        controller: propertyNameController[index],
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
                                        onFieldSubmitted: (value) => properties[index].value = value.trim(),
                                        controller: propertyValueController[index],
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          labelText: 'value'.tr,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      onFieldSubmitted: (value) => properties[index].unit = value.trim(),
                                      controller: propertyUnitController[index],
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: 'unit'.tr,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    tooltip: 'remove'.tr,
                                    iconSize: 15.0,
                                    splashRadius: 18.0,
                                    icon: const Icon(CupertinoIcons.minus_circle_fill,color: Colors.red),
                                    onPressed: () {
                                      properties.removeAt(index);
                                      propertyUnitController.removeAt(index);
                                      propertyValueController.removeAt(index);
                                      propertyNameController.removeAt(index);
                                    },

                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        TextIconButton(
                          onTap: () {
                            properties.add(Property(
                                id: null,
                                name: '',
                                description: '',
                                value: '',
                                unit: ''
                            ));
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
          const Divider(color: Colors.black),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: TextFormField(
                        controller: purchaseDateController,
                        decoration: InputDecoration(
                          labelText: 'purchase_date'.tr,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: TextFormField(
                        controller: merchantController,
                        decoration: InputDecoration(
                          labelText: 'merchant'.tr,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
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
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: TextFormField(
                        controller: invoiceNumberController,
                        decoration: InputDecoration(
                          labelText: 'invoice_number'.tr,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
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
          const SizedBox(height: 20.0),
          Expanded(
            child: Obx(() => ListView.builder(
                shrinkWrap: true,
                itemCount: bulkValues.length,
                itemBuilder: (BuildContext context, int index) => Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        bulkValues.removeAt(index);
                        serialNumberControllers.removeAt(index);
                        productionDateControllers.removeAt(index);
                        inventoryNumberControllers.removeAt(index);
                      },
                      splashRadius: 18.0,
                      icon: const Icon(CupertinoIcons.minus_circle_fill,
                        color: Colors.red,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: serialNumberControllers[index],
                        validator: (String? value) => validateSerialNumber(value!, index),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'serial_number'.tr,
                        ),
                        onFieldSubmitted: (String value) {
                          if (value.isEmpty) return;

                          List<String> serialParts = value.split(',');

                          if (bulkValues[index].value.isEmpty) {
                            for (int i = 0; i < serialParts.length; i++) {
                              bulkValues[index].value.add(SerialNumber(
                                serialNumber: serialParts[i].trim(),
                                manufacturer: merchantController.text,
                                productionDate: DateTime(4000),
                              ));
                            }
                          } else {
                            // if (bulkValues[index].value.length != serialParts.length) {
                            //   debugPrint('Unequal serialNumbers and productionDates');
                            //   //return;
                            // }

                            for (int i = 0; i < serialParts.length; i++) {
                              bulkValues[index].value[i].serialNumber = serialParts[i].trim();
                            }
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: productionDateControllers[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'production_date'.tr,
                        ),
                        onFieldSubmitted: (String value) {
                          if (value.isEmpty || serialNumberControllers[index].text.isEmpty) return;

                          List<String> productionParts = value.split(',');

                          if (bulkValues[index].value.isEmpty) {
                            final List<SerialNumber> numbers = [];

                            for (int i = 0; i < productionParts.length; i++) {
                              numbers.add(SerialNumber(
                                serialNumber: '',
                                manufacturer: merchantController.text,
                                productionDate: DateTime.parse(productionParts[i].trim()),
                              ));
                            }

                            bulkValues[index].value.addAll(numbers);
                          } else {
                            if (bulkValues[index].value.length != productionParts.length) {
                              debugPrint('Unequal serialNumbers and productionDates');
                              return;
                            }

                            for (int i = 0; i < productionParts.length; i++) {
                              bulkValues[index].value[i].serialNumber = productionParts[i].trim();
                            }
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: inventoryNumberControllers[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'inventory_number'.tr,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          ),
          TextIconButton(
            onTap: () => bulkValues.add(NonFinalMapEntry<String?, List<SerialNumber>>(null, [])),
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

  String? validateSerialNumber(String value, int index) {
    if(value.isEmpty) {
      return 'serial_num_is_mandatory'.tr;
    }

    List<String>? serialParts = value.split(',');

    if (bulkValues[index].value.length > serialParts.length) {
      return 'not_enough_serial_numbers'.tr ;
    }
    // if (bulkValues[index].value.length != serialParts.length) {
    //   return 'unequal_serialNumbers_and_production_dates'.tr ;
    // }
    return null;
  }

}


class NonFinalMapEntry<K,V> {
  K key;
  V value;

  NonFinalMapEntry(this.key, this.value);
}
