import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Central typography scale for the Notes App.
///
/// Uses the platform default font family. To adopt a custom font later, set
/// `fontFamily` on these styles or on `ThemeData` in one place.
///
/// Usage map:
/// - displayLarge: splash app name
/// - headlineMedium: home screen title
/// - headlineSmall: note title on the details screen
/// - titleLarge: app bar titles
/// - titleMedium: note tile titles
/// - titleSmall: dialog and section titles
/// - bodyLarge: note content (reading)
/// - bodyMedium: note previews and descriptions
/// - bodySmall: metadata such as dates
/// - labelLarge: buttons
/// - labelMedium: filter chips
/// - labelSmall: category badges
abstract final class AppTextTheme {
  static const TextTheme light = TextTheme(
    displayLarge: TextStyle(
      fontSize: AppDimensions.fontDisplay,
      fontWeight: FontWeight.w700,
      height: AppDimensions.lineHeightTight,
      color: AppColors.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: AppDimensions.fontXxl,
      fontWeight: FontWeight.w700,
      height: AppDimensions.lineHeightTight,
      color: AppColors.textPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: AppDimensions.fontXl,
      fontWeight: FontWeight.w700,
      height: AppDimensions.lineHeightNormal,
      color: AppColors.textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: AppDimensions.fontLg,
      fontWeight: FontWeight.w600,
      height: AppDimensions.lineHeightNormal,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: AppDimensions.fontMd,
      fontWeight: FontWeight.w600,
      height: AppDimensions.lineHeightNormal,
      color: AppColors.textPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: AppDimensions.fontSm,
      fontWeight: FontWeight.w600,
      height: AppDimensions.lineHeightNormal,
      color: AppColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: AppDimensions.fontMd,
      fontWeight: FontWeight.w400,
      height: AppDimensions.lineHeightRelaxed,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: AppDimensions.fontSm,
      fontWeight: FontWeight.w400,
      height: AppDimensions.lineHeightNormal,
      color: AppColors.textSecondary,
    ),
    bodySmall: TextStyle(
      fontSize: AppDimensions.fontXs,
      fontWeight: FontWeight.w400,
      height: AppDimensions.lineHeightNormal,
      color: AppColors.textSecondary,
    ),
    labelLarge: TextStyle(
      fontSize: AppDimensions.fontMd,
      fontWeight: FontWeight.w600,
      height: AppDimensions.lineHeightTight,
      color: AppColors.textPrimary,
    ),
    labelMedium: TextStyle(
      fontSize: AppDimensions.fontSm,
      fontWeight: FontWeight.w500,
      height: AppDimensions.lineHeightTight,
      color: AppColors.textPrimary,
    ),
    labelSmall: TextStyle(
      fontSize: AppDimensions.fontXs,
      fontWeight: FontWeight.w600,
      height: AppDimensions.lineHeightTight,
      color: AppColors.textPrimary,
    ),
  );
}
