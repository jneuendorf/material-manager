import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/extensions/user/model.dart';
import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/common/components/base_future_dialog.dart';
import 'package:frontend/common/components/multi_select_chip.dart';


class AddRoleDialog extends StatelessWidget {
  AddRoleDialog({super.key});

  static final administrationPageController = Get.find<AdministrationPageController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxList<String> selectedRights = <String>[].obs;

  final RxBool loading = false.obs;

  @override
  Widget build(BuildContext context) => BaseFutureDialog(
    size: const Size(500.0, 340.0), 
    loading: loading,
    child: Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('add_role'.tr, style: Get.textTheme.headline6),
              ),
              IconButton(
                splashRadius: 20,
                onPressed: Get.back,
                icon: const Icon(CupertinoIcons.xmark),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'name'.tr,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if(value!.isEmpty) {
                return 'name_is_mandatory'.tr;
              }
              return null;
            },
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'description'.tr,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if(value!.isEmpty) {
                return 'description_is_mandatory'.tr;
              }
              return null;
            },
          ),
          const SizedBox(height: 8.0),
          MultiSelectChip(
            options: administrationPageController.availableRights.map(
              (e) => e.name).toList(),
            selectedOptions: selectedRights,
            ),
          const SizedBox(height: 16.0),
          Align(
            alignment: Alignment.bottomRight,
            child: CupertinoButton(
              onPressed: onAddTap,
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

  /// Handles a tap on the add button.
  /// Creates [Role] and calls [UserController] to send request to server.
  Future<void> onAddTap() async {
    if (formKey.currentState!.validate()) {
      loading.value = true;
      
      // If no rights are selected, the user will only have the basic right.
      if (selectedRights.isEmpty) {
        selectedRights.value = ['Basic'];
      }

      List<Right> rights = selectedRights.map(
        (String element) => administrationPageController.availableRights.firstWhere(
          (Right right) => right.name == element)
      ).toList();

      await administrationPageController.userController.addRole(Role(
        id : null,
        name: nameController.text,
        description: descriptionController.text,
        rights: rights,
      ));

      // simulate network request
      await Future.delayed(const Duration(seconds: 1));

      loading.value = false;
    }
  }
  
}