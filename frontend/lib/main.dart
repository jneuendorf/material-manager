import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:frontend/locale_string.dart';
import 'package:frontend/api.dart';
import 'package:frontend/extensions/rental/controller.dart';
import 'package:frontend/extensions/inspection/controller.dart';
import 'package:frontend/extensions/material/controller.dart';
import 'package:frontend/extensions/user/controller.dart';
import 'package:frontend/pages/login/controller.dart';
import 'package:frontend/pages/login/page.dart';
import 'package:frontend/pages/signup/controller.dart';
import 'package:frontend/pages/signup/page.dart';
import 'package:frontend/pages/administration/controller.dart';
import 'package:frontend/pages/administration/page.dart';
import 'package:frontend/pages/administration/subpages/account_detail_page.dart';
import 'package:frontend/pages/inspection/controller.dart';
import 'package:frontend/pages/inspection/page.dart';
import 'package:frontend/pages/inventory/controller.dart';
import 'package:frontend/pages/inventory/page.dart';
import 'package:frontend/pages/lender/controller.dart';
import 'package:frontend/pages/lender/page.dart';
import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/rental/page.dart';
import 'package:frontend/pages/rental/subpages/shopping_cart_page.dart';
import 'package:frontend/pages/rental/subpages/rental_completed_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialConfig();

  runApp(const DavApp());
}

Future<void> initialConfig() async {
  await GetStorage.init();
  await Get.putAsync(() => ApiService().init());

  // init extension controllers
  Get.put(RentalController(), permanent: true);
  Get.put(MaterialController(), permanent: true);
  Get.put(UserController(), permanent: true);
  Get.put(InspectionController(), permanent: true);
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
    initialRoute: loginRoute,
    getPages: [
      GetPage(name: loginRoute, page: () => const LoginPage(),
        binding: LoginBinding(),
      ),
      GetPage(name: signupRoute, page: () => const SignupPage(),
        binding: SignupBinding(),
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
      GetPage(name: administrationRoute, page: () => const AdministrationPage(),
        binding: AdministrationPageBinding(),
      ),
      GetPage(name: administrationAccountDetailRoute, page: () => const AccountDetailPage(),
        binding: AdministrationPageBinding(),
      ),
    ],
    locale: const Locale('en', 'US'),
    translations: LocaleString(),
    fallbackLocale: const Locale('de', 'DE'),
  );
}

