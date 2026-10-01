import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/glass_theme.dart';

/// Reusable glassmorphism surface: soft backdrop blur, translucent fill,
/// light border and an elevated shadow.
///
/// All visual tokens come from [GlassTheme] (`context.glass`).
///
/// Performance: the card is wrapped in a [RepaintBoundary], and the blur can
/// be lowered with [blurSigma] or disabled with [enableBlur]. List and grid
/// tiles should pass `context.glass.blurLight`, while hero surfaces (app
/// bars, the details card) can use `context.glass.blurStrong`.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = AppDimensions.cardPadding,
    this.margin = EdgeInsets.zero,
    this.borderRadius,
    this.blurSigma,
    this.enableBlur = true,
    this.strong = false,
    this.onTap,
    this.onLongPress,
  });

  final Widget child;

  /// Space between the card edge and [child].
  final EdgeInsetsGeometry padding;

  /// Space around the card (outside the shadow).
  final EdgeInsetsGeometry margin;

  /// Falls back to the radius defined in [GlassTheme].
  final BorderRadius? borderRadius;

  /// Backdrop blur strength. Falls back to `GlassTheme.blurMedium`.
  final double? blurSigma;

  /// Set to false to skip the expensive blur (for example in long lists).
  final bool enableBlur;

  /// Uses the stronger fill and border, for prominent surfaces.
  final bool strong;

  /// Makes the card tappable with an ink ripple.
  final VoidCallback? onTap;

  /// Long-press callback (for example to delete a note).
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final GlassTheme glass = context.glass;
    final BorderRadius radius = borderRadius ?? glass.borderRadius;
    final double sigma = blurSigma ?? glass.blurMedium;

    Widget surface = Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(
          color: strong ? glass.strongFillColor : glass.fillColor,
          borderRadius: radius,
          border: Border.all(
            color: strong ? glass.strongBorderColor : glass.borderColor,
            width: glass.borderWidth,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: radius,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );

    if (enableBlur && sigma > 0) {
      surface = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: surface,
      );
    }

    return RepaintBoundary(
      child: Padding(
        padding: margin,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: <BoxShadow>[glass.boxShadow],
          ),
          child: ClipRRect(
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: surface,
          ),
        ),
      ),
    );
  }
}
