import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Glassmorphism design tokens exposed as a [ThemeExtension].
///
/// Widgets such as GlassCard read these values through `context.glass`,
/// so the whole glass look is configured in one place.
@immutable
class GlassTheme extends ThemeExtension<GlassTheme> {
  const GlassTheme({
    this.fillColor = AppColors.glassFill,
    this.strongFillColor = AppColors.glassFillStrong,
    this.borderColor = AppColors.glassBorder,
    this.strongBorderColor = AppColors.glassBorderStrong,
    this.shadowColor = AppColors.glassShadow,
    this.blurLight = AppDimensions.blurLight,
    this.blurMedium = AppDimensions.blurMedium,
    this.blurStrong = AppDimensions.blurStrong,
    this.borderWidth = AppDimensions.glassBorderWidth,
    this.shadowBlur = AppDimensions.glassShadowBlur,
    this.shadowSpread = AppDimensions.glassShadowSpread,
    this.shadowOffset = AppDimensions.glassShadowOffset,
    this.borderRadius = AppDimensions.borderRadiusXl,
  });

  /// Default light-mode glass tokens.
  static const GlassTheme light = GlassTheme();

  final Color fillColor;
  final Color strongFillColor;
  final Color borderColor;
  final Color strongBorderColor;
  final Color shadowColor;
  final double blurLight;
  final double blurMedium;
  final double blurStrong;
  final double borderWidth;
  final double shadowBlur;
  final double shadowSpread;
  final Offset shadowOffset;
  final BorderRadius borderRadius;

  /// Soft elevated shadow used behind glass surfaces.
  BoxShadow get boxShadow => BoxShadow(
    color: shadowColor,
    blurRadius: shadowBlur,
    spreadRadius: shadowSpread,
    offset: shadowOffset,
  );

  @override
  GlassTheme copyWith({
    Color? fillColor,
    Color? strongFillColor,
    Color? borderColor,
    Color? strongBorderColor,
    Color? shadowColor,
    double? blurLight,
    double? blurMedium,
    double? blurStrong,
    double? borderWidth,
    double? shadowBlur,
    double? shadowSpread,
    Offset? shadowOffset,
    BorderRadius? borderRadius,
  }) {
    return GlassTheme(
      fillColor: fillColor ?? this.fillColor,
      strongFillColor: strongFillColor ?? this.strongFillColor,
      borderColor: borderColor ?? this.borderColor,
      strongBorderColor: strongBorderColor ?? this.strongBorderColor,
      shadowColor: shadowColor ?? this.shadowColor,
      blurLight: blurLight ?? this.blurLight,
      blurMedium: blurMedium ?? this.blurMedium,
      blurStrong: blurStrong ?? this.blurStrong,
      borderWidth: borderWidth ?? this.borderWidth,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowSpread: shadowSpread ?? this.shadowSpread,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  GlassTheme lerp(ThemeExtension<GlassTheme>? other, double t) {
    if (other is! GlassTheme) return this;
    return GlassTheme(
      fillColor: Color.lerp(fillColor, other.fillColor, t) ?? fillColor,
      strongFillColor:
          Color.lerp(strongFillColor, other.strongFillColor, t) ??
          strongFillColor,
      borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      strongBorderColor:
          Color.lerp(strongBorderColor, other.strongBorderColor, t) ??
          strongBorderColor,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t) ?? shadowColor,
      blurLight: lerpDouble(blurLight, other.blurLight, t) ?? blurLight,
      blurMedium: lerpDouble(blurMedium, other.blurMedium, t) ?? blurMedium,
      blurStrong: lerpDouble(blurStrong, other.blurStrong, t) ?? blurStrong,
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t) ?? borderWidth,
      shadowBlur: lerpDouble(shadowBlur, other.shadowBlur, t) ?? shadowBlur,
      shadowSpread:
          lerpDouble(shadowSpread, other.shadowSpread, t) ?? shadowSpread,
      shadowOffset:
          Offset.lerp(shadowOffset, other.shadowOffset, t) ?? shadowOffset,
      borderRadius:
          BorderRadius.lerp(borderRadius, other.borderRadius, t) ??
          borderRadius,
    );
  }
}

/// Shortcut to read the glass tokens from any [BuildContext].
extension GlassThemeContext on BuildContext {
  GlassTheme get glass =>
      Theme.of(this).extension<GlassTheme>() ?? GlassTheme.light;
}
