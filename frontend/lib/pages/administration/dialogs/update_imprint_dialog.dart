import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/common/core/models.dart';
import 'package:frontend/common/util.dart';
import 'package:frontend/common/buttons/text_icon_button.dart';


class UpdateImprintDialog extends StatefulWidget {
  final ImprintModel imprint;
  
  const UpdateImprintDialog({super.key, required this.imprint});

  @override
  State<UpdateImprintDialog> createState() => _UpdateImprintDialogState();
}

class _UpdateImprintDialogState extends State<UpdateImprintDialog> {
  final RxList<BoardMember?> boardMembers = <BoardMember>[].obs;

  final List<TextEditingController> boardMemberControllers = <TextEditingController>[];

  final TextEditingController clubNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController registrationNumController = TextEditingController();
  final TextEditingController registryCourtController = TextEditingController();
  final TextEditingController vatNumberController = TextEditingController();
  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  final GlobalKey<FormState> formKey =  GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();

    boardMembers.listen((lst) { 
      if (boardMemberControllers.length < lst.length) {
        boardMemberControllers.add(TextEditingController());
      }
    });

    clubNameController.text = widget.imprint.clubName;
    phoneController.text = widget.imprint.phoneNumber;
    emailController.text = widget.imprint.email;
    registrationNumController.text = widget.imprint.registrationNumber.toString();
    registryCourtController.text = widget.imprint.registryCourt;
    vatNumberController.text = widget.imprint.vatNumber;

    boardMembers.value = widget.imprint.boardMembers;

    if (boardMembers.isNotEmpty) {
      for (int i = 0; i < boardMembers.length; i++) {
        boardMemberControllers.add(TextEditingController(
          text: boardMembers[i].toString(),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Dialog( 
    insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
            maxWidth: 600,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('edit_imprint'.tr, style: Get.textTheme.headline6),
                  ),
                  IconButton(
                    onPressed: Get.back,
                    splashRadius: 20,
                    icon: const Icon(CupertinoIcons.xmark),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: clubNameController,
                      decoration: InputDecoration(
                        labelText: 'club_name'.tr,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'club_name_is_mandatory'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: vatNumberController,
                      decoration: InputDecoration(
                        labelText: 'vat_number'.tr,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'vat_number_is_mandatory'.tr;
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
                      controller: registrationNumController,
                      decoration: InputDecoration(
                        labelText: 'registration_number'.tr,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'registration_number_is_mandatory'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: registryCourtController,
                      decoration: InputDecoration(
                        labelText: 'registry_court'.tr,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'registry_court_is_mandatory'.tr;
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
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 180,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Obx(() => ListView.builder(
                          shrinkWrap: true,
                          itemCount: boardMembers.length,
                          itemBuilder: (BuildContext context, int index) => Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  boardMembers.removeAt(index);
                                  boardMemberControllers.removeAt(index);
                                },
                                splashRadius: 20,
                                icon: const Icon(CupertinoIcons.xmark),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: boardMemberControllers[index],
                                  decoration: InputDecoration(
                                    labelText: 'board_member'.tr,
                                    border: const OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if(value!.isEmpty) {
                                      return 'board_member_is_mandatory'.tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        )),
                      ),
                      TextIconButton(
                        onTap: () => boardMembers.add(null), 
                        iconData: Icons.add, 
                        text: 'add_board_member'.tr,
                      ),
                    ],
                  ),
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
    ),
  );

  void onConfirmTap() {
    if (!formKey.currentState!.validate()) return;
  }
}