// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:get/get.dart';

import 'package:frontend/main.dart';
import 'package:frontend/extensions/user/mock_data.dart';
import 'package:frontend/pages/login/controller.dart';
import 'package:frontend/pages/login/page.dart';
import 'package:frontend/pages/signup/controller.dart';
import 'package:frontend/pages/signup/page.dart';
import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/rental/page.dart';
import 'package:frontend/pages/rental/subpages/shopping_cart_page.dart';
import 'package:frontend/pages/rental/subpages/rental_completed_page.dart';
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
import 'package:frontend/pages/profile/controller.dart';
import 'package:frontend/pages/profile/page.dart';
import 'package:frontend/pages/imprint/page.dart';
import 'package:frontend/pages/privacy_policy/page.dart';


void main() {
  setUp(() async  {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initialConfig();
  });

  testWidgets('LoginPage Widget Test', (WidgetTester tester) async {
    LoginPageBinding().dependencies();

    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: LoginPage()),
    ));
  });

  testWidgets('SignupPage Widget Test', (WidgetTester tester) async {
    SignupPageBinding().dependencies();

    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: SignupPage()),
    ));
  });

  testWidgets('RentalPage Widget Test', (WidgetTester tester) async {
    RentalPageBinding().dependencies();

    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: RentalPage()),
    ));
  });

  testWidgets('ShoppingCartPage Widget Test', (WidgetTester tester) async {
    RentalPageBinding().dependencies();

    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: ShoppingCartPage()),
    ));
  });

  testWidgets('RentalCompletedPage Widget Test', (WidgetTester tester) async {
    RentalPageBinding().dependencies();

    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: RentalCompletedPage()),
    ));
  });

  testWidgets('InventoryPage Widget Test', (WidgetTester tester) async {
    InventoryPageBinding().dependencies();

    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: InventoryPage()),
    ));
  });

  testWidgets('LenderPage Widget Test', (WidgetTester tester) async {
    LenderPageBinding().dependencies();

    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: LenderPage()),
    ));
  });

  testWidgets('InspectionPage Widget Test', (WidgetTester tester) async {
    InspectionPageBinding().dependencies();

    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: InspectionPage()),
    ));
  });

  testWidgets('InspectionDetailPage Widget Test', (WidgetTester tester) async {
    InspectionPageBinding().dependencies();

    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: InspectionDetailPage()),
    ));
  });

  testWidgets('AdministrationPage Widget Test', (WidgetTester tester) async {
    AdministrationPageBinding().dependencies();

    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: AdministrationPage()),
    ));
  });

  testWidgets('AccountDetailPage Widget Test', (WidgetTester tester) async {
    AdministrationPageBinding().dependencies();
    Get.find<AdministrationPageController>().selectedUser.value = mockUsers.first;

    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: AccountDetailPage()),
    ));
  });

  testWidgets('ProfilePage Widget Test', (WidgetTester tester) async {
    ProfilePageBinding().dependencies();
    Get.find<ProfilePageController>().currentUser.value = mockUsers.first;

    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: ProfilePage()),
    ));
  });

  testWidgets('ImprintPage Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: ImprintPage()),
    ));
  });

  testWidgets('PrivacyPolicyPage Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: PrivacyPolicyPage()),
    ));
  });
}
