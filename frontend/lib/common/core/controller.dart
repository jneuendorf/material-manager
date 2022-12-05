import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:get/get.dart';

import 'package:frontend/api.dart';
import 'package:frontend/common/core/models.dart';
import 'package:frontend/common/core/mock_data.dart';


/// Controller for the whole app.
/// Contains information independent of all extensions or login status.
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
    imprint.value = await getImprintMock();
  }

  Future<void> _initPrivacyPolicy() async {
    privacyPolicy.value = await getPrivacyPolicy();
  }

  /// Fetches the imprint from backend.
  /// Currently only mock data is used.
  /// A delay of 500 milliseconds is used to simulate a network request.
  Future<ImprintModel> getImprintMock() async {
    if (!kIsWeb &&  !Platform.environment.containsKey('FLUTTER_TEST')) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return mockImprint;
  }

  /// Fetches the imprint from the backend.
  Future<ImprintModel?> getImprint() async {
    // TODO implement
    return null;
  }

  /// Fetches the privacy policy from the backend.
  Future<PrivacyPolicyModel?> getPrivacyPolicy() async {
    // TODO implement
    return null;
  }

}