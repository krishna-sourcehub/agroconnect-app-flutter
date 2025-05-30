// import 'package:flutter/material.dart';
// import 'package:agroconnect/theme/button_theme.dart';
// import 'package:agroconnect/theme/input_decoration_theme.dart';
//
// import '../constants.dart';
// import 'checkbox_themedata.dart';
// import 'theme_data.dart';
//
// class AppTheme {
//   static ThemeData lightTheme(BuildContext context) {
//     return ThemeData(
//       brightness: Brightness.light,
//       fontFamily: "Plus Jakarta",
//       primarySwatch: primaryMaterialColor,
//       primaryColor: primaryColor,
//       scaffoldBackgroundColor: Colors.white,
//       iconTheme: const IconThemeData(color: blackColor),
//       textTheme: const TextTheme(
//         bodyMedium: TextStyle(color: blackColor40),
//       ),
//       elevatedButtonTheme: elevatedButtonThemeData,
//       textButtonTheme: textButtonThemeData,
//       outlinedButtonTheme: outlinedButtonTheme(),
//       inputDecorationTheme: lightInputDecorationTheme,
//       checkboxTheme: checkboxThemeData.copyWith(
//         side: const BorderSide(color: blackColor40),
//       ),
//       appBarTheme: appBarLightTheme,
//       scrollbarTheme: scrollbarThemeData,
//       dataTableTheme: dataTableLightThemeData,
//     );
//   }
//
//   // Dark theme is inclided in the Full template
// }

import 'package:agroconnect/theme/theme_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'button_theme.dart';
import 'checkbox_themedata.dart';
import 'constants.dart';
import 'input_decoration_theme.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: "Plus Jakarta",
      primarySwatch: primaryMaterialColor,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor, // ⬅ Updated
      iconTheme: const IconThemeData(color: textColor), // ⬅ Updated
      textTheme: TextTheme(
        bodyMedium: const TextStyle(color: textColor),
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
      elevatedButtonTheme: elevatedButtonThemeData,
      textButtonTheme: textButtonThemeData,
      outlinedButtonTheme: outlinedButtonTheme(borderColor: secondaryColor),
      inputDecorationTheme: lightInputDecorationTheme,
      checkboxTheme: checkboxThemeData.copyWith(
        side: BorderSide(color: borderColor.withOpacity(0.4)),
      ),
      appBarTheme: appBarLightTheme.copyWith(
        backgroundColor: backgroundColor,
        titleTextStyle: const TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: const IconThemeData(color: textColor),
      ),
      scrollbarTheme: scrollbarThemeData,
      dataTableTheme: dataTableLightThemeData,
    );
  }
}


// MaterialApp(
// theme: ThemeData(
// primaryColor: Colors.green,
// inputDecorationTheme: const InputDecorationTheme(
// focusedBorder: OutlineInputBorder(
// borderSide: BorderSide(color: Colors.green, width: 2),
// ),
// labelStyle: TextStyle(color: Colors.grey),
// ),
// ),
// home: YourHomePage(),
// )
