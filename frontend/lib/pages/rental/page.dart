import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/common/components/dav_app_bar.dart';
import 'package:frontend/common/components/dav_footer.dart';
import 'package:frontend/common/buttons/drop_down_filter_button.dart';
import 'package:frontend/common/models/material.dart';


class RentalPage extends GetView<RentalController> {
  const RentalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: kIsWeb ? const DavAppBar() : null,
    body: Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: controller.tabController,
                    indicatorColor: Get.theme.primaryColor,
                    tabs: [
                      Obx(() => Tab(
                        child: Text('single_material'.tr,
                          style: TextStyle(color: controller.tabIndex.value == 0
                              ?  Get.theme.primaryColor : null,
                          ),
                        ),
                      )),
                      Obx(() => Tab(
                        child: Text('sets'.tr,
                          style: TextStyle(color: controller.tabIndex.value == 1
                              ? Get.theme.primaryColor : null,
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                buildCartButton(),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                buildSingleMaterialPage(),
                buildSetsPage(),
              ],
            )
          ),
          if (kIsWeb) const DavFooter(),
        ],
      ),
    ),
  );

  Widget buildCartButton() => InkWell(
    onTap: () {},
    child: Container(
      width: 150,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Get.theme.colorScheme.surface,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Obx(() => Row(
        children: [
          const Icon(Icons.shopping_cart),
          const SizedBox(width: 4.0),
          Text('${controller.shoppingCart.length} ${'items'.tr}'),
          const Spacer(),
          Text('${controller.totalPrice} €'),
        ],
      )),
    ),
  );

  Widget buildBaseContainer({Widget? child}) => Container(
    padding: const EdgeInsets.all(8.0),
    margin:  const EdgeInsets.all(8.0),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Get.theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: child,
  );

  Widget buildSingleMaterialPage() => Column(
    children: [
      Row(
        children: [
          DropDownFilterButton(
            title: 'Art', 
            options: const ['All', 'Seile', 'Karabiener', 'Helme'], 
            selected: 'All', 
            onSelected: (String value) {},
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: CupertinoSearchTextField(
              placeholder: 'Suchen',
              onChanged: (String text) => controller.searchTerm.value = text,
            ),
          ),
        ],
      ),
      Expanded(
        child: buildBaseContainer(
          child: Obx(() => Wrap(
            children: controller.availibleMaterial.map((element) => MaterialPreview(
              item: element,
            )).toList(),
          )),
        ),
      ),
    ],
  );

  Widget buildSetsPage() => buildBaseContainer();
}

class MaterialPreview extends StatelessWidget {
  final MaterialModel item;

  const MaterialPreview({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(4.0),
    child: Container(
      height: 200,
      width: 200,
      color: Get.theme.colorScheme.background,
      padding: const EdgeInsets.only(top: 4.0),
      child: Column(
        children: [
          Expanded(
            child: Image.network('https://picsum.photos/250?image=9'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${item.equipmentTypes.first.description}, ${item.properties.first.value} ${item.properties.first.unit}'),
                Text('${item.rentalFee} €'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}