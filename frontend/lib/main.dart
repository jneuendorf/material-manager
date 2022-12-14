import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:frontend/api.dart';
import 'package:frontend/common/core/controller.dart';
import 'package:frontend/extensions/inspection/controller.dart';
import 'package:frontend/extensions/material/controller.dart';
import 'package:frontend/extensions/rental/controller.dart';
import 'package:frontend/extensions/user/controller.dart';
import 'package:frontend/locale_string.dart';
import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/pages/administration/page.dart';
import 'package:frontend/pages/administration/subpages/account_detail_page.dart';
import 'package:frontend/pages/inspection/controller.dart';
import 'package:frontend/pages/inspection/page.dart';
import 'package:frontend/pages/inspection/subpages/inspection_detail_page.dart';
import 'package:frontend/pages/inventory/controller.dart';
import 'package:frontend/pages/inventory/page.dart';
import 'package:frontend/pages/lender/controller.dart';
import 'package:frontend/pages/lender/page.dart';
import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/rental/page.dart';
import 'package:frontend/pages/rental/subpages/rental_completed_page.dart';
import 'package:frontend/pages/rental/subpages/shopping_cart_page.dart';
import 'package:frontend/pages/profile/controller.dart';
import 'package:frontend/pages/profile/page.dart';
import 'package:frontend/pages/login/controller.dart';
import 'package:frontend/pages/login/page.dart';
import 'package:frontend/pages/signup/controller.dart';
import 'package:frontend/pages/signup/page.dart';
import 'package:frontend/pages/imprint/page.dart';
import 'package:frontend/pages/privacy_policy/page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialConfig();

  Locale locale = await getInitialLocale();

  runApp(MaterialManagerApp(initialLocale: locale));
}

Future<void> initialConfig() async {
  await loadConfig();

  // init api service
  await Get.putAsync(() async => await ApiService().init());

  // init core controller
  Get.put(CoreController());

  // init extension controllers
  Get.lazyPut<RentalController>(() => RentalController(), fenix: true);
  Get.lazyPut<MaterialController>(() => MaterialController(), fenix: true);
  Get.lazyPut<UserController>(() => UserController(), fenix: true);
  Get.lazyPut<InspectionController>(() => InspectionController(), fenix: true);
}

/// Loads the config from the .env file.
Future<void> loadConfig() async {
  Map<String, String> envDevFile = {};
  Map<String, String> envFile = {};

  await dotenv.load(fileName: 'env/dev.env');
  envDevFile = Map<String, String>.of(dotenv.env);
  try {
    await dotenv.load(
      fileName: 'env/.env',
      // mergeWith: envDevFile,
    );
    envFile = Map<String, String>.of(dotenv.env);
  } catch (e) {
    debugPrint('$e');
  }

  await dotenv.load(
      fileName: 'env/empty.env',
      mergeWith: Map<String, String>.of({...envDevFile, ...envFile}),
  );
  debugPrint('loaded dotenv1111:');
  debugPrint('${dotenv.env}');
  debugPrint('platform env');
  debugPrint('${Platform.environment}');

  // try {
  //   debugPrint('try loading env/dev.env + env/.env...');
  //   await dotenv.load(fileName: 'env/.env');
  //   debugPrint('.env: ${dotenv.env}');
  //   Map<String, String> devDotenv = dotenv.env;
  //   await dotenv.load(fileName: 'env/dev.env');
  //   debugPrint('dev env: ${dotenv.env}');
  //   await dotenv.load(
  //     fileName: 'env/.env',
  //     // Make a shallow copy of the dev env because dotenv.env is cleared when dotenv.load is called
  //     mergeWith: Map<String, String>.of(dotenv.env),
  //   );
  //   debugPrint('env: ${dotenv.env}');
  // } catch (e) {
  //   debugPrint('$e');
  //   await dotenv.load(fileName: 'env/dev.env');
  // }
  debugPrint('loaded dotenv:');
  debugPrint('${dotenv.env}');
}

Future<Locale> getInitialLocale() async {
  // checks if running a test and return null since
  // [FlutterSecureStorage] cant be accessed in tests.
  if (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')) {
    return const Locale('en');
  }

  String? languageCode = await storage.read(key: 'locale');

  languageCode ??= 'en';

  return Locale(languageCode);
}

class MaterialManagerApp extends StatelessWidget {
  final Locale initialLocale;

  const MaterialManagerApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    title: 'Material Manager',
    theme: ThemeData(
      fontFamily: 'FiraSans',
      primaryColor: const Color.fromARGB(255, 97, 183, 50),
      colorScheme: const ColorScheme(
        primary:  Color.fromARGB(255, 97, 183, 50),
        secondary: Color.fromARGB(255, 138, 201, 101),
        surface: Color.fromRGBO(216, 216, 216, 1),
        background: Color.fromARGB(192, 216, 216, 216),
        error: Color.fromARGB(255, 227, 67, 72),
        onPrimary: Color.fromARGB(128, 97, 183, 50),
        onSecondary: Color.fromRGBO(0, 131, 199, 1),
        onSurface: Color.fromRGBO(176, 219, 153, 1),
        onBackground: Color.fromARGB(153, 216, 216, 216),
        onError: Color.fromARGB(153, 227, 67, 72),
        brightness: Brightness.light,
      ),
    ),
    initialRoute: rentalRoute,
    getPages: [
      GetPage(name: loginRoute, page: () => const LoginPage(),
        binding: LoginPageBinding(),
      ),
      GetPage(name: signupRoute, page: () => const SignupPage(),
        binding: SignupPageBinding(),
      ),
      GetPage(name: rentalRoute, page: () => const RentalPage(),
        binding: RentalPageBinding(),
      ),
      GetPage(name: rentalShoppingCartRoute, page: () => const ShoppingCartPage(),
        binding: RentalPageBinding(),
      ),
      GetPage(name: rentalCompletedRoute, page: () => const RentalCompletedPage(),
        binding: RentalPageBinding(),
      ),
      GetPage(name: inventoryRoute, page: () => const InventoryPage(),
        binding: InventoryPageBinding(),
      ),
      GetPage(name: lenderRoute, page: () => const LenderPage(),
        binding: LenderPageBinding(),
      ),
      GetPage(name: inspectionRoute, page: () => const InspectionPage(),
        binding: InspectionPageBinding(),
      ),
      GetPage(name: inspectionDetailRoute, page: () => const InspectionDetailPage(),
        binding: InspectionPageBinding(),
      ),
      GetPage(name: administrationRoute, page: () => const AdministrationPage(),
        binding: AdministrationPageBinding(),
      ),
      GetPage(name: administrationAccountDetailRoute, page: () => const AccountDetailPage(),
        binding: AdministrationPageBinding(),
      ),
      GetPage(name: profileRoute, page: () => const ProfilePage(),
        binding: ProfilePageBinding(),
      ),
      // Following pages don´t need a binding, since they don´t use a controller.
      // This is the case for pages that only display hardcoded information.
      GetPage(name: privacyPolicyRoute, page: () => const PrivacyPolicyPage()),
      GetPage(name: imprintRoute, page: () => const ImprintPage()),
    ],
    locale: initialLocale,
    translations: LocaleString(),
    fallbackLocale: const Locale('de', 'DE'),
  );
}
