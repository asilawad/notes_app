import 'package:flutter/widgets.dart';
import 'package:notes_app/core/config/constants/app_sizes.dart';

/// Device size category derived from screen width.
enum ScreenType { phone, tablet, desktop }

/// Lightweight responsive helpers available on any [BuildContext].
///
/// Uses [MediaQuery.sizeOf], so a widget rebuilds only when the screen size
/// changes, not on keyboard or padding changes.
extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  ScreenType get screenType {
    final double width = screenWidth;
    if (width >= AppDimensions.desktopBreakpoint) return ScreenType.desktop;
    if (width >= AppDimensions.tabletBreakpoint) return ScreenType.tablet;
    return ScreenType.phone;
  }

  bool get isPhone => screenType == ScreenType.phone;

  bool get isTablet => screenType == ScreenType.tablet;

  bool get isDesktop => screenType == ScreenType.desktop;

  /// Number of columns for the notes grid on the current screen.
  int get gridColumns => switch (screenType) {
    ScreenType.phone => AppDimensions.gridColumnsPhone,
    ScreenType.tablet => AppDimensions.gridColumnsTablet,
    ScreenType.desktop => AppDimensions.gridColumnsDesktop,
  };

  /// Ratio between the current width and the reference design width,
  /// clamped so the UI never shrinks or grows too much.
  double get scaleFactor {
    final double rawFactor = screenWidth / AppDimensions.designReferenceWidth;
    return rawFactor
        .clamp(AppDimensions.minScaleFactor, AppDimensions.maxScaleFactor)
        .toDouble();
  }

  /// Scales [value] proportionally to the screen width.
  ///
  /// Use it only for sizes that should grow with the screen (logo, empty
  /// state image, large headings), not for every padding.
  double scale(double value) => value * scaleFactor;
}
