import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:frontend/api.dart';
import 'package:frontend/home/controller.dart';
import 'package:frontend/home/page.dart';
import 'package:frontend/login/controller.dart';
import 'package:frontend/login/page.dart';
import 'package:frontend/internationalization/locale_string.dart';


void main() {
  runApp(const DavApp());
}

Future<void> initialConfig() async {
  await GetStorage.init();
  await Get.putAsync(() => ApiService().init());
}

class DavApp extends StatelessWidget {
  const DavApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    title: 'Material Verleih',
    // theme: ThemeData(), // TODO: Add theme
    initialRoute: loginRoute,
    getPages: [
      GetPage(name: homeRoute, page: () => const HomePage(),
        binding: HomeBinding(),
      ),
      GetPage(name: loginRoute, page: () => const LoginPage(),
        binding: LoginBinding(),
      ),
    ],
    locale: const Locale('en', 'US'),
    translations: LocaleString(),
    fallbackLocale: const Locale('de', 'DE'),
  );
}

