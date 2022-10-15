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
    theme: ThemeData(
      fontFamily: 'FiraSans',
      primaryColor: const Color.fromARGB(255, 97, 183, 50),
      colorScheme: const ColorScheme(
        primary:  Color.fromARGB(255, 97, 183, 50),
        secondary: Color.fromARGB(255, 138, 201, 101),
        surface: Color.fromARGB(188, 63, 63, 63),
        background: Color.fromARGB(192, 216, 216, 216),
        error: Color.fromARGB(255, 227, 67, 72),
        onPrimary: Color.fromARGB(128, 97, 183, 50),
        onSecondary: Color.fromARGB(128, 97, 183, 50),
        onSurface: Color.fromARGB(128, 63, 63, 63),
        onBackground: Color.fromARGB(153, 216, 216, 216),
        onError: Color.fromARGB(153, 227, 67, 72),
        brightness: Brightness.light,
      ),
    ),
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

