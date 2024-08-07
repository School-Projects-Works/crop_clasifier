import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyles {
  TextStyle titleStyle({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w700,
    double letterSpacing = 1.2,
    double height = 1.5,
    Color color = const Color(0xFF000000),
  }) {
    return GoogleFonts.roboto(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  TextStyle bodyStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color color = const Color(0xFF000000),
    double letterSpacing = 1.2,
    double height = 1.5,
    
  }) {
    return GoogleFonts.roboto(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
     
      
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