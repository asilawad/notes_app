import 'package:flutter/animation.dart';

/// Central animation timing for the Notes App.
///
/// Every Duration used for animations, delays, debounce and feedback must be
/// defined here. Curves live in [AppCurves] in this same file.
abstract final class AppDurations {
  // ---------------------------------------------------------------------------
  // Splash
  // ---------------------------------------------------------------------------
  /// Fade and scale entry animation of the logo.
  static const Duration splashAnimation = Duration(milliseconds: 1200);

  /// Total time on the splash screen before navigating to Home.
  /// Must stay greater than [splashAnimation].
  static const Duration splashTotal = Duration(milliseconds: 2200);

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Duration heroTransition = Duration(milliseconds: 400);

  // ---------------------------------------------------------------------------
  // List animations
  // ---------------------------------------------------------------------------
  /// Fade and slide duration of a single list item.
  static const Duration listItemAnimation = Duration(milliseconds: 400);

  /// Delay added per item to create the staggered entry effect.
  static const Duration listItemStagger = Duration(milliseconds: 60);

  /// Items beyond this index share the same delay, so long lists never wait.
  static const int maxStaggerItems = 8;

  // ---------------------------------------------------------------------------
  // Micro-interactions
  // ---------------------------------------------------------------------------
  static const Duration chipSelection = Duration(milliseconds: 200);
  static const Duration layoutSwitch = Duration(milliseconds: 300);
  static const Duration fabAnimation = Duration(milliseconds: 250);
  static const Duration fadeSwitcher = Duration(milliseconds: 250);
  static const Duration skeletonPulse = Duration(milliseconds: 900);

  // ---------------------------------------------------------------------------
  // Input
  // ---------------------------------------------------------------------------
  /// Delay before the search query triggers filtering.
  static const Duration searchDebounce = Duration(milliseconds: 300);

  // ---------------------------------------------------------------------------
  // Feedback
  // ---------------------------------------------------------------------------
  static const Duration snackbar = Duration(seconds: 3);

  /// Longer so the user has time to tap Undo after deleting.
  static const Duration undoSnackbar = Duration(seconds: 4);
}

/// Central animation curves for the Notes App.
abstract final class AppCurves {
  static const Curve standard = Curves.easeInOut;
  static const Curve entrance = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutBack;
}
