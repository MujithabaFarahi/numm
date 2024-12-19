import 'package:flutter/material.dart';

class ColorPalette {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color primaryBlue = Color(0xFF2A5BE8);
  static const Color primaryTextColor = Color(0xFF252525);

  static const Map<int, Color> mainPeach = {
    100: Color(0xFFFDF3F3), // Level 1
    200: Color(0xFFFCE4E5), // Level 2
    300: Color(0xFFFACECF), // Level 3
    400: Color(0xFFF7B3B5), // Level 4
    500: Color(0xFFEF7A7D), // Level 5
    600: Color(0xFFE35054), // Level 6
  };

  static const Map<int, Color> mainPurple = {
    100: Color(0xFFFBF6FF), // Level 1
    200: Color(0xFFF6E9FE), // Level 2
    300: Color(0xFFEED7FD), // Level 3
    400: Color(0xFFCD8AF6), // Level 4
    500: Color(0xFFA73CE1), // Level 5
    600: Color(0xFF7928A1), // Level 6
  };

  static const Map<int, Color> mainBlue = {
    100: Color(0xFFE7ECFF), // Light Level 1
    200: Color(0xFFC9D8FF), // Light Level 2
    300: Color(0xFFA9C4FF), // Light Level 3
    400: Color(0xFF5F8DFF), // Mid Level 4
    500: Color(0xFF2A5BE8), // Bold Level 5
    600: Color(0xFF0A0740), // Darkest Level 6
  };

  static const Map<int, Color> mainGray = {
    100: Color(0xFFFAFAFA), // Level 1
    200: Color(0xFFE7E7E7), // Level 2
    300: Color(0xFFD1D1D1), // Level 3
    400: Color(0xFFB0B0B0), // Level 4
    500: Color(0xFF888888), // Level 5
    600: Color(0xFF252525), // Level 6
  };

  static const Map<int, Color> positiveColor = {
    100: Color(0xFFE7F3EB), // Level 1
    200: Color(0xFFB6D8C2), // Level 2
    300: Color(0xFF92C6A4), // Level 3
    400: Color(0xFF13823A), // Level 4
    500: Color(0xFF117635), // Level 5
    600: Color(0xFF004F1C), // Level 6
  };

  static const Map<int, Color> negativeColor = {
    100: Color(0xFFF8E9E8), // Level 1
    200: Color(0xFFE8B9B9), // Level 2
    300: Color(0xFFDD9897), // Level 3
    400: Color(0xFFB61E1D), // Level 4
    500: Color(0xFFA61B1A), // Level 5
    600: Color(0xFF790B0A), // Level 6
  };

  static LinearGradient primaryGradient = LinearGradient(
    colors: [mainPurple[400]!, mainPeach[400]!],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
