import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/responsive/responsive.dart';

/// Screen backdrop: a soft gradient with two blurred-looking color blobs.
///
/// The blobs give the glass cards something colorful to blur, so the
/// glassmorphism effect is actually visible on a light background.
///
/// Blobs are drawn with radial gradients instead of a blur filter, which is
/// far cheaper to render. The decoration is isolated in a [RepaintBoundary],
/// so it is painted once and never repainted while content scrolls.
///
/// Usage: `Scaffold(body: GradientBackground(child: SafeArea(...)))`.
class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.showBlobs = true,
  });

  final Widget child;

  /// Set to false for a plain gradient without the decorative blobs.
  final bool showBlobs;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        RepaintBoundary(
          child: ExcludeSemantics(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: AppColors.backgroundGradient,
                ),
                child: showBlobs ? _buildBlobs(context) : null,
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildBlobs(BuildContext context) {
    final double largeSize = context.scale(AppDimensions.blobLargeSize);
    final double smallSize = context.scale(AppDimensions.blobSmallSize);
    final double largeOffset = context.scale(AppDimensions.blobLargeOffset);
    final double smallOffset = context.scale(AppDimensions.blobSmallOffset);

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: <Widget>[
        Positioned(
          top: largeOffset,
          right: largeOffset,
          child: _Blob(size: largeSize, color: AppColors.blobSky),
        ),
        Positioned(
          bottom: smallOffset,
          left: smallOffset,
          child: _Blob(size: smallSize, color: AppColors.blobAmber),
        ),
      ],
    );
  }
}

/// A circle whose color fades smoothly to fully transparent at its edge.
class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: <Color>[color, color.withAlpha(0)]),
      ),
    );
  }
}
