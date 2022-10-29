import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/pages/profile/controller.dart';
import 'package:frontend/common/components/page_wrapper.dart';


class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PageWrapper(
    pageTitle: 'profile'.tr,
    child: Center(
      child: Text('profile'.tr),
    ),
  );
}