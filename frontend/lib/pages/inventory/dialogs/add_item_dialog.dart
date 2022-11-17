import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  //gets incremented by counter and by "add_serial_number", in case its a set with multiple serial_numbers
  final RxInt serialNumberCount =0.obs;

  @override
  Widget build(BuildContext context) => BaseFutureDialog(
    //size: Size.infinite,//const Size(800.0, 540.0),
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
                splashRadius: 20,
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
                    decoration: InputDecoration(
                      labelText: 'rental_fee'.tr,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0,bottom: 50.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 50.0),
                                child: TextFormField(
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
                                  decoration: InputDecoration(
                                    labelText: 'max_service_duration'.tr,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'instructions'.tr,
                          ),
                        ),
                      ),
                      TextFormField(
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
                      Obx(() => ListView.builder(
                          shrinkWrap: true,
                          itemCount: properties.length,
                          itemBuilder: (context, index) =>  Card(
                            elevation: 5,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'name'.tr,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'value'.tr,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
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
                            decoration: InputDecoration(
                              labelText: 'merchant'.tr,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'purchase_price'.tr,
                          ),
                        ),
                      ),
                    ]
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 50.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'invoice_number'.tr,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 50.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'production_date'.tr,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
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
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Obx(() =>ListView.builder(
                      shrinkWrap: true,
                      itemCount: counter.value,
                      itemBuilder: (context, index) =>  Card(
                        elevation: 5,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'serial_number'.tr,
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
                    ),),
                    TextIconButton(
                      onTap: () {},
                      iconData: Icons.add,
                      text: 'add_serial_number'.tr,
                      color: Get.theme.colorScheme.onSecondary,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Obx(() => ListView.builder(
                      shrinkWrap: true,
                      itemCount: counter.value,
                      itemBuilder: (context, index) =>  Card(
                        elevation: 5,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'name'.tr,
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
                    ),),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Obx(() => Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              counter -= 1;
                            });
                          },
                        ),
                        Text(counter.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              counter += 1;
                            });
                          },
                        ),
                      ])
                  )),
                  CupertinoButton(
                      onPressed: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.5),
                          child: Text('add'.tr, style: const TextStyle(color: Colors.black)),
                        ),
                      )
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
