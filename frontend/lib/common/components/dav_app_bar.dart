import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/home/controller.dart';
import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/inventory/controller.dart';
import 'package:frontend/pages/inspection/controller.dart';
import 'package:frontend/pages/lender/controller.dart';
import 'package:frontend/pages/administration/controller.dart';


class DavAppBar extends StatelessWidget with PreferredSizeWidget{
  const DavAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    title: const Text('Material Verleih'),
    actions: kIsWeb ? [
      TextButton(
        onPressed: () => Get.offNamed(homeRoute + rentalRoute), 
        child: const Text('Rental', 
          style: TextStyle(color: Colors.white),
        ),
      ),
      TextButton(
        onPressed: () => Get.offNamed(homeRoute + inventoryRoute),
        child: const Text('Inventroy', 
          style: TextStyle(color: Colors.white),
        ),
      ),
      TextButton(
        onPressed: () => Get.offNamed(homeRoute + inspectionRoute),
        child: const Text('Inspection', 
        style: TextStyle(color: Colors.white),
        ),
      ),
      TextButton(
        onPressed: () => Get.offNamed(homeRoute + lenderRoute),
        child: const Text('Lender', 
        style: TextStyle(color: Colors.white),
        ),
      ),
      TextButton(
        onPressed: () => Get.offNamed(homeRoute + administrationRoute),
        child: const Text('Administration', 
        style: TextStyle(color: Colors.white),
        ),
      ),
    ] : null,
  );

}