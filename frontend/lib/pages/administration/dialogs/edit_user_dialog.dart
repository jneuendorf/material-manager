import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

// import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/common/components/base_future_dialog.dart';
import 'package:frontend/common/util.dart';


class EditUserDialog extends StatefulWidget {
  final UserModel user;

  const EditUserDialog({super.key, required this.user});

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> with SingleTickerProviderStateMixin {
  //final administrationPageController = Get.find<AdministrationPageController>();

  late TabController tabController;

  final RxInt tabIndex = 0.obs;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController membershipController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxBool loading = false.obs;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });

    firstNameController.text = widget.user.firstName;
    lastNameController.text = widget.user.lastName;
    emailController.text = widget.user.email;
    phoneController.text = widget.user.phone;
    membershipController.text = widget.user.membershipNumber;
  }

  @override
  Widget build(BuildContext context) => BaseFutureDialog(
    loading: loading,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 550),
      child: Form(
        key: formKey,
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('edit_user'.tr, style: Get.textTheme.headline6),
                ),
                IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(CupertinoIcons.xmark),
                ),
              ],
            ),
            TabBar(
              controller: tabController,
              indicatorColor: Get.theme.primaryColor,
              tabs: [
                Obx(() => Tab(
                  child: Text('general'.tr,
                    style: TextStyle(
                      color: tabIndex.value == 0
                          ? Get.theme.primaryColor
                          : null,
                    ),
                  ),
                )),
                Obx(() => Tab(
                  child: Text('address'.tr,
                    style: TextStyle(
                      color: tabIndex.value == 1
                          ? Get.theme.primaryColor
                          : null,
                    ),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 16.0),
            Flexible(
              child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  buildGerneralScreen(),
                  buildAdressScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    ), 
  );

  Widget buildGerneralScreen() => Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      const SizedBox(height: 8.0),
      isLargeScreen(Get.context!) ? Row(
        children: [
          Expanded(child: buildFirstNameTextField()),
          const SizedBox(width: 8.0),
          Expanded(child: buildLastNameTextField()),
        ],
      ) : Column(
        children:[
          buildFirstNameTextField(),
          const SizedBox(height: 8.0),
          buildLastNameTextField(),
        ],
      ),
      const SizedBox(height: 8.0),
      TextFormField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'email'.tr,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (!GetUtils.isEmail(value!)) {
            return 'email_not_valid'.tr;
          } 
          return null;
        },
      ),
      const SizedBox(height: 8.0),
      TextFormField(
        controller: phoneController,
        decoration: InputDecoration(
          labelText: 'phone'.tr,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (!GetUtils.isPhoneNumber(value!)) {
            return 'phone_not_valid'.tr;
          }
          return null;
        },
      ),
      const SizedBox(height: 8.0),
      TextFormField(
        controller: membershipController,
        decoration: InputDecoration(
          labelText: 'membership_number'.tr,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if(value!.isEmpty) {
            return 'membership_num_is_mandatory'.tr;
          }
          final membershipNum = RegExp(r'\d{5}');
          if(!membershipNum.hasMatch(value)){
            return 'invalid_membership_num'.tr;
          }
          return null;
        },
      ),
      const SizedBox(height: 16.0),
      Align(
        alignment: Alignment.bottomRight,
        child: CupertinoButton(
          onPressed: onConfirmTap,
          color: Get.theme.primaryColor,
          child: Text('confirm'.tr,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    ],
  );

  Widget buildAdressScreen() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [],
  );

  TextFormField buildFirstNameTextField() => TextFormField(
    controller: firstNameController,
    decoration: InputDecoration(
      labelText: 'first_name'.tr,
      border: const OutlineInputBorder(),
    ),
    validator: (value) {
      if(value!.isEmpty) {
        return 'name_is_mandatory'.tr;
      }
      return null;
    },
  );

  TextFormField buildLastNameTextField() => TextFormField(
    controller: lastNameController,
    decoration: InputDecoration(
      labelText: 'last_name'.tr,
      border: const OutlineInputBorder(),
    ),
    validator: (value) {
      if(value!.isEmpty) {
        return 'name_is_mandatory'.tr;
      }
      return null;
    },
  );

  Future<void> onConfirmTap() async {
    if (formKey.currentState!.validate()) {
      loading.value = true;
    }
  }
}
