import 'package:flutter/material.dart';

/// Central layout tokens for the Notes App.
///
/// Every padding, margin, radius, size, blur value and breakpoint used in the
/// UI must be defined here. Raw numbers are not allowed in views or widgets.
abstract final class AppDimensions {
  // ---------------------------------------------------------------------------
  // Spacing scale
  // ---------------------------------------------------------------------------
  static const double spaceXxs = 4;
  static const double spaceXs = 8;
  static const double spaceSm = 12;
  static const double spaceMd = 16;
  static const double spaceLg = 20;
  static const double spaceXl = 24;
  static const double spaceXxl = 32;
  static const double spaceXxxl = 48;

  // ---------------------------------------------------------------------------
  // Common paddings
  // ---------------------------------------------------------------------------
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: spaceMd,
    vertical: spaceSm,
  );
  static const EdgeInsets cardPadding = EdgeInsets.all(spaceMd);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: spaceSm,
    vertical: spaceXs,
  );
  static const EdgeInsets badgePadding = EdgeInsets.symmetric(
    horizontal: spaceXs,
    vertical: spaceXxs,
  );
  static const EdgeInsets inputContentPadding = EdgeInsets.symmetric(
    horizontal: spaceMd,
    vertical: spaceSm,
  );
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: spaceXl,
    vertical: spaceSm,
  );
  static const EdgeInsets listBottomPadding = EdgeInsets.only(
    left: spaceMd,
    right: spaceMd,
    bottom: fabListInset,
  );

  /// Extra bottom space so the last list item is not hidden by the FAB.
  static const double fabListInset = 96;

  // ---------------------------------------------------------------------------
  // Border radius
  // ---------------------------------------------------------------------------
  static const double radiusXs = 6;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusXxl = 28;
  static const double radiusPill = 100;

  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(radiusMd),
  );
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(radiusLg),
  );
  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(radiusXl),
  );
  static const BorderRadius borderRadiusPill = BorderRadius.all(
    Radius.circular(radiusPill),
  );

  // ---------------------------------------------------------------------------
  // Glassmorphism
  // ---------------------------------------------------------------------------
  /// Light blur for list/grid tiles (keeps scrolling smooth).
  static const double blurLight = 6;

  /// Default blur for standard glass surfaces.
  static const double blurMedium = 12;

  /// Strong blur for hero surfaces (app bars, dialogs, detail card).
  static const double blurStrong = 20;

  static const double glassBorderWidth = 1;
  static const double glassShadowBlur = 24;
  static const double glassShadowSpread = 0;
  static const Offset glassShadowOffset = Offset(0, 8);

  // ---------------------------------------------------------------------------
  // Icons
  // ---------------------------------------------------------------------------
  static const double iconXs = 14;
  static const double iconSm = 18;
  static const double iconMd = 24;
  static const double iconLg = 32;

  // ---------------------------------------------------------------------------
  // Elevation & borders
  // ---------------------------------------------------------------------------
  static const double elevationNone = 0;
  static const double elevationLow = 4;
  static const double borderWidth = 1;
  static const double borderWidthFocused = 1.5;

  // ---------------------------------------------------------------------------
  // Typography
  // ---------------------------------------------------------------------------
  static const double fontXs = 12;
  static const double fontSm = 14;
  static const double fontMd = 16;
  static const double fontLg = 18;
  static const double fontXl = 22;
  static const double fontXxl = 28;
  static const double fontDisplay = 36;

  static const double lineHeightTight = 1.25;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.6;

  // ---------------------------------------------------------------------------
  // Components
  // ---------------------------------------------------------------------------
  static const double buttonHeight = 52;
  static const double textFieldHeight = 56;
  static const double searchBarHeight = 52;
  static const double chipHeight = 36;
  static const double fabSize = 60;
  static const double appBarHeight = 64;
  static const double categoryBadgeHeight = 24;
  static const double progressIndicatorSize = 28;
  static const double progressIndicatorStroke = 3;
  static const double buttonMinWidth = 120;

  // ---------------------------------------------------------------------------
  // Note tiles
  // ---------------------------------------------------------------------------
  static const int noteListTitleMaxLines = 1;
  static const int noteListPreviewMaxLines = 3;
  static const int noteGridTitleMaxLines = 2;
  static const int noteGridPreviewMaxLines = 5;
  static const double noteGridAspectRatio = 0.85;
  static const double noteGridSpacing = spaceSm;
  static const double noteListSpacing = spaceSm;
  static const double skeletonTileHeight = 120;
  static const int skeletonItemCount = 6;
  static const double skeletonLineHeight = 14;
  static const double skeletonBadgeWidth = 72;
  static const double skeletonTitleWidthFactor = 0.6;
  static const double skeletonLineWidthFactor = 1;
  static const double skeletonShortLineWidthFactor = 0.75;

  /// Lowest opacity of the pulsing skeleton (it pulses between this and 1).
  static const double skeletonMinOpacity = 0.5;

  // ---------------------------------------------------------------------------
  // Note form
  // ---------------------------------------------------------------------------
  static const int noteContentMinLines = 10;
  static const int noteTitleMaxLength = 100;
  static const int noteContentMaxLength = 5000;

  // ---------------------------------------------------------------------------
  // Detail screen
  // ---------------------------------------------------------------------------
  /// Keeps the reading column comfortable on tablets and wide screens.
  static const double contentMaxWidth = 720;

  // ---------------------------------------------------------------------------
  // Splash & empty state
  // ---------------------------------------------------------------------------
  static const double splashLogoSize = 120;
  static const double emptyStateImageSize = 180;
  static const double emptyStateIconSize = 64;
  static const double errorStateCircleSize = 120;
  static const double errorStateIconSize = 48;

  // ---------------------------------------------------------------------------
  // Decorative background blobs
  // ---------------------------------------------------------------------------
  static const double blobLargeSize = 280;
  static const double blobSmallSize = 200;
  static const double blobLargeOffset = -80;
  static const double blobSmallOffset = -60;

  // ---------------------------------------------------------------------------
  // Animation offsets
  // ---------------------------------------------------------------------------
  static const double listItemSlideOffset = 24;
  static const double splashScaleBegin = 0.85;

  // ---------------------------------------------------------------------------
  // Breakpoints & responsive grid
  // ---------------------------------------------------------------------------
  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 900;
  static const int gridColumnsPhone = 2;
  static const int gridColumnsTablet = 3;
  static const int gridColumnsDesktop = 4;

  /// Reference design width used by the responsive scaling helper.
  static const double designReferenceWidth = 390;

  /// Limits for the responsive scale factor, so UI never shrinks or grows too much.
  static const double minScaleFactor = 0.85;
  static const double maxScaleFactor = 1.3;
}
