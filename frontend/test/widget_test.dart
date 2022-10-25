// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart';
import 'package:frontend/pages/login/controller.dart';
import 'package:frontend/pages/login/page.dart';
import 'package:frontend/pages/rental/controller.dart';
import 'package:frontend/pages/rental/page.dart';
import 'package:frontend/pages/signup/controller.dart';
import 'package:frontend/pages/signup/page.dart';


void main() {
  
  testWidgets('LoginPage Widget Test', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    await initialConfig();
    LoginBinding().dependencies();

    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: LoginPage()),
    ));
  });

  testWidgets('SignupPage Widget Test', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    await initialConfig();
    SignupBinding().dependencies();

    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: SignupPage()),
    ));
  });

  testWidgets('RentalPage Widget Test', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    await initialConfig();
    RentalPageBinding().dependencies();

    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: RentalPage()),
    ));
  });
}
