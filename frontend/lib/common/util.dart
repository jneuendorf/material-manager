import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;


/// Checks if the screen is larger than 600.
bool isLargeScreen(BuildContext context) => MediaQuery.of(context).size.width > 600;

/// Returns the rendered size of the given [text].
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

void downloadWeb(String name, String url) => html.AnchorElement(
      href: url)
    ..setAttribute('download', name)
    ..click();

/// Saves the given [bytes] as a file with the given [name]
/// in the downloads directory.
/// Returns whether successful.
/// Be carefule not to overwrite existing files by choosing a likely
/// unique filename (e.g. timestamp).
/// To use this with a string. Convert it with string.codeUnits
Future<bool> downloadBytes(String name, List<int> bytes, {String mimeType = ''}) async {
  if (kIsWeb) {
    final base64 = convert.base64UrlEncode(bytes);
    final url = 'data:$mimeType;base64,$base64';

    downloadWeb(name, url);
  } else {
    try {
      if (!await Permission.storage.request().isGranted) return false;

      Directory documentDir = await getApplicationDocumentsDirectory();

      final file = File(p.join(documentDir.path, name));
      await file.writeAsBytes(bytes);
      debugPrint('File saved to: ${file.path}');
    } catch (e) {
      debugPrint('Error while downloading file: $e');
      return false;
    }
  }
  return true;
}

/// Shows a file picker dialog and returns the selected files.
/// Returns null if the user cancels the dialog.
Future<List<XFile>?> pickImages() async => await ImagePicker().pickMultiImage();


intl.DateFormat dateFormat = intl.DateFormat('dd.MM.yyyy');

/// Returns the given [date] as a string in the format dd.MM.yyyy.
String formatDate(DateTime? date) {
  return date != null ? dateFormat.format(date) : '';
}
