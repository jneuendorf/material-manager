import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  final inventoryPageController = Get.find<InventoryPageController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxBool loading = false.obs;
  final RxBool showSearch = false.obs;

  final FocusNode searchFocusNode = FocusNode();

  final Rxn<MaterialTypeModel> selectedType = Rxn<MaterialTypeModel>();
  final RxList<MaterialTypeModel> filteredTypes = <MaterialTypeModel>[].obs;
  final RxList<Property> properties = <Property>[].obs;
  final RxList<NonFinalMapEntry<String?, List<SerialNumber>>> bulkValues = <NonFinalMapEntry<String?, List<SerialNumber>>>[
    NonFinalMapEntry(null, <SerialNumber>[]),
  ].obs;

  final TextEditingController materialTypeController = TextEditingController();
  final TextEditingController rentalFeeController = TextEditingController();
  final TextEditingController maxLifeExpectancyController = TextEditingController();
  final TextEditingController maxServiceDurationController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController nextInspectionController = TextEditingController();
  final TextEditingController purchaseDateController = TextEditingController();
  final TextEditingController merchantController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController();
  final TextEditingController invoiceNumberController = TextEditingController();
  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController suggestedRetailPriceController = TextEditingController();

  List<TextEditingController> propertyNameController = <TextEditingController>[];
  List<TextEditingController> propertyValueController = <TextEditingController>[];
  List<TextEditingController> propertyUnitController = <TextEditingController>[];

  final List<TextEditingController> serialNumberControllers = <TextEditingController>[
    TextEditingController(),
  ];
  final List<TextEditingController> productionDateControllers = <TextEditingController>[
    TextEditingController(),
  ];
  final List<TextEditingController> inventoryNumberControllers = <TextEditingController>[
    TextEditingController(),
  ];

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

    properties.listen((List<Property> lst) {
      if (propertyNameController.length < lst.length) {
        propertyNameController = List.generate(lst.length, (index) => TextEditingController(
          text: lst[index].propertyType.name,
        ));
        propertyUnitController = List.generate(lst.length, (index) => TextEditingController(
          text: lst[index].propertyType.unit,
        ));
        propertyValueController = List.generate(lst.length, (index) => TextEditingController(
          text: lst[index].value,
        ));
      }
    });

    searchFocusNode.addListener(() {
      Future.delayed(const Duration(milliseconds: 100)).then(
        (_) => showSearch.value = searchFocusNode.hasFocus,
      ); 
    });

    selectedType.listen((MaterialTypeModel? type ) async {
      if (type == null) {
        properties.clear();
        return;
      }

      final propertyTypes = await inventoryPageController.materialController.getPropertyTypesByMaterialTypeName(type.name);
      debugPrint('propertyTypes: $propertyTypes');
      properties.value = propertyTypes?.map(
        (PropertyType e) => Property(
          id: e.id,
          value: '',
          propertyType: e,
        ),
      ).toList() ?? [];
    });

    filteredTypes.value = inventoryPageController.materialController.types;
  }

  @override
  void dispose() {
    searchFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BaseFutureDialog(
    loading: loading,
    child: Form(
      key: formKey,
      child: Column(
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
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 292,
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextFormField(
                              controller: materialTypeController,
                              focusNode: searchFocusNode,
                              decoration: InputDecoration(
                                labelText: 'material_type'.tr,
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'material_type_is_mandatory'.tr;
                                }
                                return null;
                              },
                              onChanged: (String value) => filteredTypes.value = inventoryPageController.materialController.types.where(
                                (type) => type.name.toLowerCase().contains(value.toLowerCase()),
                              ).toList(),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: maxLifeExpectancyController,
                                    decoration: InputDecoration(
                                      labelText: 'max_life_expectancy'.tr,
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'max_life_expectancy_is_mandatory'.tr;
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'max_life_expectancy_must_be_a_number'.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: maxServiceDurationController,
                                    decoration: InputDecoration(
                                      labelText: 'max_service_duration'.tr,
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'max_service_duration_is_mandatory'.tr;
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'max_service_duration_must_be_a_number'.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            TextFormField(
                              controller: nextInspectionController,
                              decoration: InputDecoration(
                                labelText: 'next_inspection'.tr,
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'next_inspection_is_mandatory'.tr;
                                }
                                if (double.tryParse(value) == null) {
                                  return 'next_inspection_must_be_a_number'.tr;
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: TextFormField(
                                controller: instructionsController,
                                decoration: InputDecoration(
                                  labelText: 'instructions'.tr,
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'instructions_are_mandatory'.tr;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        Obx(() => showSearch.value ? Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Card(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                for (final materialType in filteredTypes)
                                  ListTile(
                                    title: Text(materialType.name),
                                    onTap: () {
                                      materialTypeController.text = materialType.name;
                                      selectedType.value = materialType;
                                      searchFocusNode.unfocus();
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ) : const SizedBox()),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0,),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TextFormField(
                            controller: rentalFeeController,
                            decoration: InputDecoration(
                              labelText: 'rental_fee'.tr,
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'rental_fee_is_mandatory'.tr;
                              }
                              if (double.tryParse(value) == null) {
                                return 'rental_fee_must_be_a_number'.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: Obx(() => ListView.separated(
                            separatorBuilder: (context, index) => const SizedBox(height: 8.0),
                              shrinkWrap: true,
                              itemCount: properties.length,
                              itemBuilder: (context, index) =>  Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: TextFormField(
                                        onFieldSubmitted: (value) => properties[index].propertyType.name = value.trim(),
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
                                      onFieldSubmitted: (value) => properties[index].propertyType.unit = value.trim(),
                                      controller: propertyUnitController[index],
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: 'unit'.tr,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    tooltip: 'remove_property'.tr,
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
                          onTap: () => properties.add(Property(
                            id: null,
                            value: '',
                            propertyType: PropertyType(
                              id: null,
                              name: '',
                              unit: '',
                              description: '',
                            ),
                          )),
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
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'purchase_date_is_mandatory'.tr;
                          }
                          return null;
                        },
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
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'merchant_is_mandatory'.tr;
                          }
                          return null;
                        },
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
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'purchase_price_is_mandatory'.tr;
                        }
                        if (double.tryParse(value) == null) {
                          return 'purchase_price_must_be_a_number'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: TextFormField(
                        controller: invoiceNumberController,
                        decoration: InputDecoration(
                          labelText: 'invoice_number'.tr,
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'invoice_number_is_mandatory'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: TextFormField(
                        controller: manufacturerController,
                        decoration: InputDecoration(
                          labelText: 'manufacturer'.tr,
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'manufacturer_is_mandatory'.tr;
                          }
                          return null;
                        },
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
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'suggested_retail_price_is_mandatory'.tr;
                        }
                        if (double.tryParse(value) == null) {
                          return 'suggested_retail_price_must_be_a_number'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          //const SizedBox(height: 16.0),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Obx(() => ListView.separated(
                shrinkWrap: true,
                itemCount: bulkValues.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8.0),
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
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'serial_number'.tr,
                        ),
                        validator: (String? value) => validateSerialNumber(value!, bulkValues[index]),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onFieldSubmitted: (String value) {
                          if (value.trim().isEmpty) return;

                          List<String> serialParts = value.split(',');
                          serialParts.removeWhere((element) => element.trim() == '');

                          if (bulkValues[index].value.isEmpty) {
                            for (int i = 0; i < serialParts.length; i++) {
                              bulkValues[index].value.add(SerialNumber(
                                serialNumber: serialParts[i].trim(),
                                manufacturer: merchantController.text,
                                productionDate: DateTime(4000),
                              ));
                            }
                          } else {
                            for (int i = 0; i < bulkValues[index].value.length; i++) {
                              if (i > serialParts.length - 1) {
                                bulkValues[index].value[i].serialNumber = '';
                              } else {
                                bulkValues[index].value[i].serialNumber = serialParts[i].trim();
                              }
                            }

                            bulkValues[index].value.removeWhere(
                              (element) => element.productionDate == DateTime(4000) && element.serialNumber.isEmpty);

                            if (bulkValues[index].value.length < serialParts.length) {
                              for (int i = bulkValues[index].value.length; i < serialParts.length; i++) {
                                debugPrint('Addding serialNumber: ${serialParts[i].trim()} with length: ${serialParts[i].trim().length}');
                                bulkValues[index].value.add(SerialNumber(
                                  serialNumber: serialParts[i].trim(),
                                  manufacturer: merchantController.text,
                                  productionDate: DateTime(4000),
                                ));
                              }
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: TextFormField(
                        controller: productionDateControllers[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'production_date'.tr,
                        ),
                        validator: (String? value) => validateProductionDate(value!,  bulkValues[index]),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onFieldSubmitted: (String value) {
                          if (value.trim().isEmpty) return;

                          List<String> productionParts = value.split(',');
                          productionParts.removeWhere((element) => element.trim() == '');

                          if (bulkValues[index].value.isEmpty) {
                            final List<SerialNumber> numbers = [];

                            for (int i = 0; i < productionParts.length; i++) {
                              numbers.add(SerialNumber(
                                serialNumber: '',
                                manufacturer: merchantController.text,
                                productionDate: DateFormat('dd.MM.yyy').parse(productionParts[i].trim()),
                              ));
                            }

                            bulkValues[index].value.addAll(numbers);
                          } else {
                            for (int i = 0; i < bulkValues[index].value.length; i++) {
                              if (i > productionParts.length - 1) {
                                bulkValues[index].value[i].productionDate = DateTime(4000);
                              } else {
                                bulkValues[index].value[i].productionDate = DateFormat('dd.MM.yyy').parse(productionParts[i].trim());
                              }
                            }

                            bulkValues[index].value.removeWhere(
                              (element) => element.productionDate == DateTime(4000) && element.serialNumber.isEmpty);

                            if (bulkValues[index].value.length < productionParts.length) {
                              for (int i = bulkValues[index].value.length; i < productionParts.length; i++) {
                                bulkValues[index].value.add(SerialNumber(
                                  serialNumber: '',
                                  manufacturer: merchantController.text,
                                  productionDate: DateFormat('dd.MM.yyy').parse(productionParts[i].trim()),
                                ));
                              }
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: TextFormField(
                        controller: inventoryNumberControllers[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'inventory_number'.tr,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'inventory_number_is_mandatory'.tr;
                          }
                          return null;
                        },
                        onFieldSubmitted: (String value) {
                          if (value.trim().isEmpty) return;

                          bulkValues[index].key = value.trim();
                        },
                      ),
                    ),
                  ],
                ),
              )),
            ),
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
              onPressed: onAdd,
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

  void onAdd() {
    if (!formKey.currentState!.validate()) return;

    for (var element in bulkValues) {
      debugPrint('InventoryNumber:${element.key!} Serials:${element.value.map((e) => '${e.serialNumber},').toList()}, Prod.Dates:${element.value.map((e) => '${e.productionDate},').toList()}');
    }
  }

  String? validateSerialNumber(String value, NonFinalMapEntry<String?, List<SerialNumber>> entry) {
    if(value.isEmpty) {
      return 'serial_num_is_mandatory'.tr;
    }

    List<String>? serialParts = value.split(',');
    serialParts.removeWhere((element) => element.trim() == '');

    if (entry.value.length > serialParts.length) {
      return 'not_enough_serial_numbers'.tr ;
    }

    return null;
  }

  String? validateProductionDate(String value, NonFinalMapEntry<String?, List<SerialNumber>> entry) {
    if(value.isEmpty) {
      return 'production_date_is_mandatory'.tr;
    }

    List<String>? productionParts = value.split(',');
    productionParts.removeWhere((element) => element.trim() == '');

    if (entry.value.length > productionParts.length) {
      return 'not_enough_production_dates'.tr ;
    }

    return null;
  }

}


class NonFinalMapEntry<K,V> {
  K key;
  V value;

  NonFinalMapEntry(this.key, this.value);
}
