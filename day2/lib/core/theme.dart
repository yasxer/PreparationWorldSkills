import 'package:flutter/material.dart';

class AppTheme {
  // تصفية نوع المتغير (Color) والكتابة الصحيحة للكلمة
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color backgroundColor = Color(0xFFF8FAFC); // هنا صححنا السامبلينغ

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor, // الكلمة الصحيحة

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16,horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: Colors.black54
        ),

      )
    );
  }
}