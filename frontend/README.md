# frontend

## Running

Run `flutter run -d <device>` to run on specific device.

**Example:** `flutter run -d chrome` to run in Chrome browser.


## Linting

Active linting rules can be found in the `analysis_options.yaml` file.

**List of rules:** https://dart-lang.github.io/linter/lints/index.html


## StateManagement

Currently using GetX (https://pub.dev/packages/get), which combines high-performance state management, intelligent dependency injection, and route management quickly and practically.

**Note:** This package can later also be used for internationalization (https://medium.com/rajtechnologies/flutter-getx-localization-multi-languages-change-app-language-a73f6f62f50a).


## Internationalization

Translations must be registerd in the `lib/locale_string.dart` file.

These can  be accessed via `'<key>'.tr` in the code.

