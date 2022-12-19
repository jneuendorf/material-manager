import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:frontend/pages/inventory/controller.dart';
import 'package:frontend/extensions/material/model.dart';
import 'package:frontend/common/util.dart';

class ProductDetailsDialog extends StatelessWidget {
  final MaterialModel item;

  const ProductDetailsDialog({super.key, required this.item});

  static final inventoryPageController = Get.find<InventoryPageController>();

  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('product_details'.tr,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                        Text('${'manufacturer'.tr} : ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                        Text(item.serialNumbers[0].manufacturer,
                          style: const TextStyle(fontSize: 15.0)
                        ),
                        ]
                      ),
                      Row(
                      children: [
                        Text('${'inventory_number'.tr} : ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                        Text(item.inventoryNumbers.map((x) => x.inventoryNumber).join(', '),
                          style: const TextStyle(fontSize: 15.0),
                        ),
                        ]
                      ),
                      Row(
                        children: [
                        Text('${'max_operating_years'.tr} : ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                        Text('${item.maxOperatingYears}',
                          style: const TextStyle(fontSize: 15.0)
                        ),
                        ]
                      ),
                      Row(
                        children: [
                        Text('${'max_days_used'.tr} : ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            ),
                          ),
                        Text('${item.maxDaysUsed}',
                            style: const TextStyle(fontSize: 15.0)
                        ),
                        ]
                      ),
                      Row(
                        children: [
                        Text('${'instructions'.tr} : ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                        InkWell(
                          onTap: ()  async {
                            if (!await launchUrl(Uri.parse(item.instructions))) {
                              Get.snackbar('error'.tr, 'could_not_launch_url'.tr);
                            }
                          },
                          child: Text(item.instructions,
                            style: TextStyle(fontSize: 15.0,color: Get.theme.colorScheme.onSecondary,)
                          ),
                        ),
                        ]
                      ),
                      for(var property in item.properties) Row(
                        children: [
                          Text('${property.propertyType.name} : ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            )
                          ),
                          Text(property.value + property.propertyType.unit,
                            style: const TextStyle(fontSize: 15.0)
                          ),
                        ],
                      ),
                    ],
                  )
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${'merchant'.tr} : ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          Text(item.purchaseDetails.merchant.toString(),
                          style: const TextStyle(fontSize: 15.0),
                          ),
                        ]
                      ),
                      Row(
                        children: [
                          Text('${'invoice_number'.tr} : ',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)
                            ),
                          Text(item.purchaseDetails.invoiceNumber.toString(),
                            style: const TextStyle(fontSize: 15.0),
                          ),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Text('${'production_date'.tr} : ',
                      //       style: const TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 15.0,
                      //       ),
                      //     ),
                      //     Text(inventoryPageController.formatDate(item.purchaseDetails.productionDate),
                      //       style: const TextStyle(fontSize: 15.0)
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: [
                          Text('${'purchase_date'.tr} : ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          Text(formatDate(item.purchaseDetails.purchaseDate),
                            style: const TextStyle(fontSize: 15.0)
                          ),
                        ]
                      ),
                      Row(
                        children: [
                          Text('${'purchase_price'.tr} : ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          Text('${item.purchaseDetails.purchasePrice}€',
                            style: const TextStyle(fontSize: 15.0)
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('${'suggested_retail_price'.tr} : ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          Text('${item.purchaseDetails.suggestedRetailPrice}€',
                            style: const TextStyle(fontSize: 15.0)
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
