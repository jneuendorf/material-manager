import 'package:flutter/material.dart';
import 'package:frontend/pages/rental/controller.dart';
import 'package:get/get.dart';


/// Builds a [TextFormField] with the given [controller], [labelText]
/// and [validator].
/// The [onValidChanged] callback is called when the [TextFormField] has been
/// changed and validated by the [validator].
Widget buildCustomTextField({
  required Rx<TextEditingController> controller,
  required String labelText,
  required String? Function(String?)? validator,
  void Function(String)? onValidChanged,
  required RxBool hadError,
}) {
  final rentalPageController = Get.find<RentalPageController>();
  controller.value.addListener(() {
    if (hadError.value) rentalPageController.shoppingCartFormKey.currentState!.validate();
  });

  return Obx(() => TextFormField(
    controller: controller.value,
    readOnly: true,
    decoration: InputDecoration(
      focusColor: Colors.white,
      prefixIcon: const Icon(Icons.calendar_today),
      labelText: labelText,
      enabledBorder: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(),
      errorBorder: const OutlineInputBorder(),
    ),
    onTap: () async {
      controller.value.text = (await rentalPageController.pickDate()) ?? '';

      if (validator!(controller.value.text) != null || onValidChanged == null) return;

      onValidChanged(controller.value.text);
    },
    validator: (String? s) {
      String? errorMsg =  validator!(s);
      if (errorMsg != null) {
        hadError.value = true;
      }
      return errorMsg;
    },
  ));
}
