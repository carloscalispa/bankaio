// lib/core/theme/theme.dart

import 'package:flutter/material.dart';
import '../config/environment.dart';

class AppTheme {
  static ThemeData get theme {
    final color = _parseColor(Environment.themeColorHex);
    return ThemeData(
      primaryColor: color,
    //  scaffoldBackgroundColor: color, // Fondo ligeramente tintado
      appBarTheme: AppBarTheme(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: color,
      ),
    );
  }

  static Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
