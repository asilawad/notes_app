import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'app_text_theme.dart';
import 'glass_theme.dart';

/// Global [ThemeData] for the Notes App (soft light mode).
///
/// Component themes here style every Material widget once, so custom widgets
/// stay small and never define their own colors, radii or text styles.
abstract final class AppTheme {
  static final ThemeData light = _buildLight();

  static ThemeData _buildLight() {
    final TextTheme textTheme = AppTextTheme.light;

    return ThemeData(
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: AppDimensions.iconMd,
      ),
      extensions: const <ThemeExtension<dynamic>>[GlassTheme.light],
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.transparent,
        surfaceTintColor: AppColors.transparent,
        elevation: AppDimensions.elevationNone,
        scrolledUnderElevation: AppDimensions.elevationNone,
        centerTitle: false,
        toolbarHeight: AppDimensions.appBarHeight,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: AppDimensions.iconMd,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.glassFillStrong,
        contentPadding: AppDimensions.inputContentPadding,
        hintStyle: textTheme.bodyLarge?.copyWith(color: AppColors.textHint),
        errorStyle: textTheme.bodySmall?.copyWith(color: AppColors.error),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
        border: _inputBorder(AppColors.inputBorder, AppDimensions.borderWidth),
        enabledBorder: _inputBorder(
          AppColors.inputBorder,
          AppDimensions.borderWidth,
        ),
        focusedBorder: _inputBorder(
          AppColors.primary,
          AppDimensions.borderWidthFocused,
        ),
        errorBorder: _inputBorder(AppColors.error, AppDimensions.borderWidth),
        focusedErrorBorder: _inputBorder(
          AppColors.error,
          AppDimensions.borderWidthFocused,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          shadowColor: AppColors.transparent,
          elevation: AppDimensions.elevationNone,
          minimumSize: const Size(
            AppDimensions.buttonMinWidth,
            AppDimensions.buttonHeight,
          ),
          padding: AppDimensions.buttonPadding,
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusLg,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMd,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: AppDimensions.elevationLow,
        iconSize: AppDimensions.iconMd,
        sizeConstraints: BoxConstraints.tightFor(
          width: AppDimensions.fabSize,
          height: AppDimensions.fabSize,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusXl,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.glassFill,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.backgroundAlt,
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: AppColors.textOnPrimary,
        ),
        padding: AppDimensions.chipPadding,
        elevation: AppDimensions.elevationNone,
        pressElevation: AppDimensions.elevationNone,
        showCheckmark: false,
        side: const BorderSide(
          color: AppColors.glassBorderStrong,
          width: AppDimensions.glassBorderWidth,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusPill,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.transparent,
        elevation: AppDimensions.elevationLow,
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
        shape: const RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusXl,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        actionTextColor: AppColors.primaryLight,
        elevation: AppDimensions.elevationLow,
        insetPadding: const EdgeInsets.all(AppDimensions.spaceMd),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textOnPrimary,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMd,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: AppDimensions.glassBorderWidth,
        space: AppDimensions.spaceMd,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.textSelection,
        selectionHandleColor: AppColors.primary,
      ),
    );
  }

  static ColorScheme get _colorScheme => const ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.textOnPrimary,
    primaryContainer: AppColors.backgroundTint,
    onPrimaryContainer: AppColors.primary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.textPrimary,
    error: AppColors.error,
    onError: AppColors.textOnPrimary,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    outline: AppColors.inputBorder,
    outlineVariant: AppColors.divider,
  );

  static OutlineInputBorder _inputBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: AppDimensions.borderRadiusLg,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
