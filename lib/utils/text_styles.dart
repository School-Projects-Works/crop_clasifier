import 'dart:ui';

import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyles {
  TextStyle titleStyle({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w700,

    Color color = const Color(0xFF000000),
  }) {
    return GoogleFonts.roboto(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  TextStyle bodyStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color color = const Color(0xFF000000),
  }) {
    return GoogleFonts.roboto(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  TextStyle buttonStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w700,
    Color color = const Color(0xFF000000),
  }) {
    return GoogleFonts.roboto(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  TextStyle captionStyle({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w400,
    Color color = const Color(0xFF000000),
  }) {
    return GoogleFonts.roboto(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}