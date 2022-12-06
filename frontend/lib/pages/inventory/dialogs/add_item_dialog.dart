import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cross_file/cross_file.dart';

import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/pages/inventory/controller.dart';
import 'package:frontend/common/components/base_future_dialog.dart';
import 'package:frontend/common/buttons/text_icon_button.dart';
import 'package:frontend/common/core/models.dart';
import 'package:frontend/common/util.dart';


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
  
  final RxList<XFile> images = <XFile>[].obs;
  XFile? instructions;

  final TextEditingController materialTypeController = TextEditingController();
  final TextEditingController rentalFeeController = TextEditingController();
  final TextEditingController maxLifeExpectancyController = TextEditingController();
  final TextEditingController maxOperatingDateController = TextEditingController();
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                                              if (int.tryParse(value) == null) {
                                                return 'max_life_expectancy_must_be_a_number'.tr;
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: maxOperatingDateController,
                                            decoration: InputDecoration(
                                              labelText: 'max_operating_date'.tr,
                                            ),
                                            validator: (String? value) {
                                              if (value == null || value.isEmpty) {
                                                return 'max_operating_date_is_mandatory'.tr;
                                              }
                                              if (tryParseDate(value) == null) {
                                                return 'must_be_date_format'.tr;
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
                                        if (tryParseDate(value) == null) {
                                          return 'must_be_date_format'.tr;
                                        }
                                        return null;
                                      },
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: instructionsController,
                                            decoration: InputDecoration(
                                              labelText: 'instructions'.tr,
                                            ),
                                            validator: (String? value) {
                                              if (value == null || value.isEmpty) {
                                                return null;
                                              }
                                              if (value != 'file_selected'.tr && !value.isURL) {
                                                return 'must_be_file_or_url'.tr;
                                              }
                                            },
                                          ),
                                        ),
                                        IconButton(
                                          splashRadius: 18.0,
                                          onPressed: () async {
                                            instructions = await pickFile();
                                            if (instructions == null) return;

                                            instructionsController.text = 'file_selected'.tr;
                                          },
                                          icon: const Icon(Icons.folder),
                                        ),
                                      ],
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
                          const SizedBox(width: 8.0),
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
                                                onChanged: (String value) => properties[index].propertyType.name = value.trim(),
                                                controller: propertyNameController[index],
                                                decoration: InputDecoration(
                                                  border: const OutlineInputBorder(),
                                                  labelText: 'name'.tr,
                                                ),
                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                validator: (String? value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'property_name_is_mandatory'.tr;
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: TextFormField(
                                                onChanged: (String value) => properties[index].value = value.trim(),
                                                controller: propertyValueController[index],
                                                decoration: InputDecoration(
                                                  border: const OutlineInputBorder(),
                                                  labelText: 'value'.tr,
                                                ),
                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                validator: (String? value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'property_value_is_mandatory'.tr;
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              onChanged: (String value) => properties[index].propertyType.unit = value.trim(),
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
                                  if (tryParseDate(value) == null) {
                                    return 'must_be_date_format'.tr;
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
                                if (value != null && double.tryParse(value) == null) {
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
                                  bulkValues[index].key = value.trim();
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextIconButton(
                      onTap: () => bulkValues.add(NonFinalMapEntry<String?, List<SerialNumber>>(null, [])),
                      iconData: Icons.add,
                      text: 'add_item'.tr,
                      color: Get.theme.colorScheme.onSecondary,
                    ),
                  ),
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 150.0),
                      child: Obx(() => ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (XFile image in images)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: kIsWeb
                                      ? Image.network(image.path).image
                                      : Image.file(File(image.path)).image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () => images.remove(image),
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 6.0, right: 6.0,
                                      ),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child:  Icon(Icons.close),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Container(
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Get.theme.colorScheme.onSecondary),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(Icons.image),
                                    Text('add_image'.tr),
                                    FloatingActionButton(
                                      onPressed: () async => images.addAll(
                                        (await pickImages()) ?? []),
                                      backgroundColor: Get.theme.colorScheme.onSecondary,
                                      foregroundColor: Colors.white,
                                      elevation: 10,
                                      child: const Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )),
                    ),
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
          ),
        ],
      ),
    ),
  );

  /// Handles tap on the add button.
  Future<void> onAdd() async {
    if (!formKey.currentState!.validate()) return;

    debugPrint('Prperties: $properties');

    loading.value = true;

    final int? statusCode = await inventoryPageController.materialController.addMaterials(
      imageFiles: images,
      bulkValues: bulkValues,
      materialType: selectedType.value ?? MaterialTypeModel(
        id: null, 
        name: materialTypeController.text, 
        description: '',
      ),
      properties: properties,
      rentalFee: double.parse(rentalFeeController.text),
      maxOperatingDate: dateFormat.parse(maxOperatingDateController.text),
      maxDaysUsed: int.parse(maxLifeExpectancyController.text),
      nextInspectionDate: dateFormat.parse(nextInspectionController.text),
      merchant: merchantController.text,
      instructions: instructionsController.text,
      purchaseDate: dateFormat.parse(purchaseDateController.text),
      purchasePrice: double.parse(purchasePriceController.text),
      suggestedRetailPrice: double.parse(suggestedRetailPriceController.text),
      invoiceNumber: invoiceNumberController.text,
      manufacturer: manufacturerController.text,
    );

    if (statusCode == null) {
      loading.value = false;
    } else {
      // since potentially new material, new types and new properties could have been added,
      // we can just call the init function to refresh the data
      inventoryPageController.materialController.onInit();
      inventoryPageController.onInit();
      // the futures must not be awaited because the state changes as soon as the initCompleter is completed
      Get.back();
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

    if (entry.value.isEmpty) {
      for (int i = 0; i < serialParts.length; i++) {
        entry.value.add(SerialNumber(
          serialNumber: serialParts[i].trim(),
          manufacturer: manufacturerController.text,
          productionDate: DateTime(4000),
        ));
      }
    } else {
      for (int i = 0; i < entry.value.length; i++) {
        if (i > serialParts.length - 1) {
          entry.value[i].serialNumber = '';
        } else {
          entry.value[i].serialNumber = serialParts[i].trim();
        }
      }

      entry.value.removeWhere(
        (element) => element.productionDate == DateTime(4000) && element.serialNumber.isEmpty);

      if (entry.value.length < serialParts.length) {
        for (int i = entry.value.length; i < serialParts.length; i++) {
          entry.value.add(SerialNumber(
            serialNumber: serialParts[i].trim(),
            manufacturer: manufacturerController.text,
            productionDate: DateTime(4000),
          ));
        }
      }
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

    if (productionParts.any((productionDate) => tryParseDate(productionDate) == null)) {
      return 'must_be_date_format'.tr;
    }

    if (entry.value.isEmpty) {
      final List<SerialNumber> numbers = [];

      for (int i = 0; i < productionParts.length; i++) {
        numbers.add(SerialNumber(
          serialNumber: '',
          manufacturer: manufacturerController.text,
          productionDate: DateFormat('dd.MM.yyy').parse(productionParts[i].trim()),
        ));
      }

      entry.value.addAll(numbers);
    } else {
      for (int i = 0; i < entry.value.length; i++) {
        if (i > productionParts.length - 1) {
          entry.value[i].productionDate = DateTime(4000);
        } else {
          entry.value[i].productionDate = DateFormat('dd.MM.yyy').parse(productionParts[i].trim());
        }
      }

      entry.value.removeWhere(
        (element) => element.productionDate == DateTime(4000) && element.serialNumber.isEmpty);

      if (entry.value.length < productionParts.length) {
        for (int i = entry.value.length; i < productionParts.length; i++) {
          entry.value.add(SerialNumber(
            serialNumber: '',
            manufacturer: manufacturerController.text,
            productionDate: DateFormat('dd.MM.yyy').parse(productionParts[i].trim()),
          ));
        }
      }
    }

    return null;
  }

  DateTime? tryParseDate(String input) {
    try {
      return dateFormat.parse(input);
    } on FormatException {
      return null;
    }
  }

}
