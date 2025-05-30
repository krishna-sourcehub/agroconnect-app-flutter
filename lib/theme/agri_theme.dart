import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData agricultureTheme = ThemeData(
  primaryColor: AppColors.primaryGreen,
  scaffoldBackgroundColor: AppColors.lightBeige,
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: AppColors.darkOlive),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
);
