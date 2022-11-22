import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:permission_handler/permission_handler.dart';

/// Checks if the screen is larger than 600.
bool isLargeScreen(BuildContext context) => MediaQuery.of(context).size.width > 600;

void downloadWeb(String name, String url) => html.AnchorElement(
      href: name)
    ..setAttribute('download', name)
    ..click();

/// Downloading a pseudo file just means that we are not actually downloading a file but raw data.
/// However, we want the user to feel like he is downloading a file
/// Returns whether successful
/// 
/// Be carefule not to overwrite existing files by choosing a likely unique filename (e.g. timestamp)
/// To use this with a string. Convert it with string.codeUnits
Future<bool> downloadPseudoFile(String name, List<int> bytes, {String mimeType = ''}) async {
  // https://itnext.io/cross-platform-file-downloads-using-flutter-6723d40ee730
  // Das hier wäre natürlich alles viel einfacher mit einer Datei, die auf dem Server liegt.
  if (kIsWeb) {
    final base64 = convert.base64UrlEncode(bytes);
    final url = 'data:$mimeType;base64,$base64';
    // This works for non-data urls. See (https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/Data_URLs#common_problems) security issues
    // html.window.open(url, name);
    downloadWeb(name, url);
  } else {
    try {
      if (!await Permission.storage.request().isGranted) {
        return false;
      }
      final documentDir = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
      final file = File(p.join(documentDir.path, name));
      await file.writeAsBytes(bytes);
    } catch (_) {
      return false;
    }
  }
  return true;
}

/// Returs the rendered size of the given [text]. 
Size getTextSize({
  required String text, 
  TextStyle? style, 
  int? maxLines,
  double maxWidth = double.infinity,
  double textScaleFactor = 1.0,
}) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), 
        maxLines: maxLines, 
        textDirection: TextDirection.ltr,
        textScaleFactor: textScaleFactor,
    )..layout(minWidth: 0, maxWidth: maxWidth);

    return textPainter.size;
  }