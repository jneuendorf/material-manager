import 'package:flutter/material.dart';


/// Checks if the screen is larger than 600.
bool isLargeScreen(BuildContext context) => MediaQuery.of(context).size.width > 600;

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