import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/common/components/base_future_dialog.dart';
import 'package:frontend/common/components/multi_select_chip.dart';
import 'package:frontend/common/util.dart';


class EditUserDialog extends StatefulWidget {
  final String title;
  final Future<bool> Function(UserModel) onConfirm;
  final UserModel? user;

  const EditUserDialog({
    super.key, 
    required this.title, 
    required this.onConfirm,
    this.user,
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> with SingleTickerProviderStateMixin {
  final administrationPageController = Get.find<AdministrationPageController>();

  late TabController tabController;

  final RxInt tabIndex = 0.obs;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController membershipController = TextEditingController();
  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxList<String> selectedRoles = <String>[].obs;

  final RxBool loading = false.obs;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });

    if (widget.user != null) {
      firstNameController.text = widget.user!.firstName;
      lastNameController.text = widget.user!.lastName;
      emailController.text = widget.user!.email;
      phoneController.text = widget.user!.phone;
      membershipController.text = widget.user!.membershipNumber;
      streetNameController.text = widget.user!.address.street;
      houseNumberController.text = widget.user!.address.houseNumber;
      cityController.text = widget.user!.address.city;
      zipController.text = widget.user!.address.zip;

      selectedRoles.value = widget.user!.roles.map(
        (Role role) => role.name
      ).toList();
    }
  }

  @override
  Widget build(BuildContext context) => BaseFutureDialog(
    loading: loading,
    child: ConstrainedBox(
      constraints: const BoxConstraints(
          maxWidth: 600,
        ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(widget.title, style: Get.textTheme.headline6),
                ),
                IconButton(
                  onPressed: Get.back,
                  splashRadius: 20,
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
            SizedBox(
              height: isLargeScreen(context) ? 250 : 360,
              child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  buildGerneralScreen(),
                  buildAdressScreen(),
                ],
              ),
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
        ),
      ),
    ), 
  );

  Widget buildGerneralScreen() => Column(
    mainAxisSize: MainAxisSize.min,
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
      if (isLargeScreen(Get.context!)) const SizedBox(height: 8.0),
      MultiSelectChip(
        options: administrationPageController.userController.roles.map(
          (Role role) => role.name).toList(),
        selectedOptions: selectedRoles,
      ),
    ],
  );

  Widget buildAdressScreen() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const SizedBox(height: 8.0),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: streetNameController,
              decoration: InputDecoration(
                labelText: 'street_name'.tr,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if(value!.isEmpty) {
                  return 'street_is_mandatory'.tr;
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 8.0),
          SizedBox(
            width: isLargeScreen(Get.context!) ? 200 : 100,
            child: TextFormField(
              controller: houseNumberController,
              decoration: InputDecoration(
                labelText: 'house_number'.tr,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if(value!.isEmpty) {
                  return 'housenumber_is_mandatory'.tr;
                }
                return null;
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 8.0),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: 'city'.tr,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if(value!.isEmpty) {
                  return 'city_is_mandatory'.tr;
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 8.0),
          SizedBox(
            width: isLargeScreen(Get.context!) ? 200 : 100,
            child: TextFormField(
              controller: zipController,
              decoration: InputDecoration(
                labelText: 'zip'.tr,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if(value!.isEmpty) {
                  return 'zip_is_mandatory'.tr;
                }
                return null;
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 8.0),
      isLargeScreen(context) ? Row(
        children: [
          Expanded(
            child: buildEmailTextField(),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: buildEmailTextField(),
          ),
        ],
      ) : Column(
        children: [
          buildEmailTextField(),
          const SizedBox(height: 8.0),
          buildPhoneTextField(),
        ],
      ),
      
    ],
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

  TextFormField buildEmailTextField() => TextFormField(
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
    );

    TextFormField buildPhoneTextField() => TextFormField(
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
  );

  Future<void> onConfirmTap() async {
    if (formKey.currentState!.validate()) {
      loading.value = true;
    } else {
      return;
    }

    final List<Role> roles = selectedRoles.map(
      (String name) => administrationPageController.userController.roles.firstWhere(
        (Role role) => role.name == name)
    ).toList();

    UserModel updatedUser = UserModel(
      id: widget.user?.id,
      roles: roles,
      category: widget.user?.category,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      membershipNumber: membershipController.text,
      phone: phoneController.text,
      address: Address(
        street: streetNameController.text,
        houseNumber: houseNumberController.text,
        city: cityController.text,
        zip: zipController.text,
      ),
    );

    final bool success = await widget.onConfirm(updatedUser);

    if (success) {
      Get.back();
    } 

    loading.value = false;
  }
}
