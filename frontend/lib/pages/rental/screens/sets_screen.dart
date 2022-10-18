import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/rental/components/template_widget.dart';
import 'package:frontend/common/models/material.dart';


class SetsScreen extends StatelessWidget {
  const SetsScreen({super.key});

  static final rentalController = Get.find<RentalController>();

  @override
  Widget build(BuildContext context) => TemplateWidget(
    headerWidget: Container(),
    materialList: <MaterialModel>[].obs,
  );
}