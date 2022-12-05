import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/common/core/models.dart';


class CoreController extends GetxController {
  static final apiService = Get.find<ApiService>();

  final Completer initCompleter = Completer();

  final Rxn<ImprintModel> imprint = Rxn<ImprintModel>();
  final Rxn<PrivacyPolicyModel> privacyPolicy = Rxn<PrivacyPolicyModel>();

  @override
  Future<void> onInit() async {
    super.onInit();

    debugPrint('CoreController init');

    initCompleter.future;

    if (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')) {
      initCompleter.complete();
      return;
    }

    await Future.wait([
      _initImprint(),
      _initPrivacyPolicy(),
    ]);

    initCompleter.complete();
  }

  Future<void> _initImprint() async {
    imprint.value = await getImprint();
  }

  Future<void> _initPrivacyPolicy() async {
    privacyPolicy.value = await getPrivacyPolicy();
  }

  Future<ImprintModel?> getImprint() async {
    // TODO implement
    return null;
  }

  Future<PrivacyPolicyModel?> getPrivacyPolicy() async {
    // TODO implement
    return null;
  }

}