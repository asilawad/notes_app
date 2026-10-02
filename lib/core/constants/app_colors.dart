import 'package:flutter/material.dart';

/// Central color palette for the Notes App.
///
/// Every color used anywhere in the app must be defined here.
/// Translucent colors use const ARGB literals, where the first byte is alpha:
/// 0x1A ≈ 10%, 0x26 ≈ 15%, 0x33 ≈ 20%, 0x40 ≈ 25%, 0x66 ≈ 40%, 0x99 ≈ 60%.
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Brand
  // ---------------------------------------------------------------------------
  static const Color primary = Color(0xFF0284C7);
  static const Color primaryLight = Color(0xFF38BDF8);
  static const Color secondary = Color(0xFFF59E0B);
  static const Color accent = Color(0xFFEF4444);
  static const Color warmBrown = Color(0xFF78350F);

  // ---------------------------------------------------------------------------
  // Backgrounds & surfaces
  // ---------------------------------------------------------------------------
  static const Color background = Color(0xFFF8FAFC);
  static const Color backgroundAlt = Color(0xFFF1F5F9);
  static const Color backgroundTint = Color(0xFFE0F2FE);
  static const Color surface = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------------
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Borders & dividers
  // ---------------------------------------------------------------------------
  static const Color divider = Color(0xFFE2E8F0);
  static const Color inputBorder = Color(0xFFCBD5E1);

  // ---------------------------------------------------------------------------
  // Glassmorphism
  // ---------------------------------------------------------------------------
  /// Default glass card fill (white, ~40%).
  static const Color glassFill = Color(0x66FFFFFF);

  /// Stronger glass fill for elevated surfaces such as app bars (white, ~60%).
  static const Color glassFillStrong = Color(0x99FFFFFF);

  /// Light glass border (white, 20%).
  static const Color glassBorder = Color(0x33FFFFFF);

  /// More visible glass border for light backgrounds (white, ~50%).
  static const Color glassBorderStrong = Color(0x80FFFFFF);

  /// Soft elevated shadow behind glass cards (slate, ~10%).
  static const Color glassShadow = Color(0x1A0F172A);

  // ---------------------------------------------------------------------------
  // Decorative background blobs (make the glass blur visible)
  // ---------------------------------------------------------------------------
  static const Color blobSky = Color(0x4038BDF8);
  static const Color blobAmber = Color(0x33F59E0B);

  // ---------------------------------------------------------------------------
  // Feedback
  // ---------------------------------------------------------------------------
  static const Color error = accent;
  static const Color errorTint = Color(0x26EF4444);

  // ---------------------------------------------------------------------------
  // Utility
  // ---------------------------------------------------------------------------
  static const Color transparent = Color(0x00000000);

  /// Placeholder bars in loading skeletons (slate, ~12%).
  static const Color skeleton = Color(0x1F94A3B8);

  /// Text selection highlight (sky blue, ~30%).
  static const Color textSelection = Color(0x4D38BDF8);

  // ---------------------------------------------------------------------------
  // Note categories (solid color + soft tint for badges/chips)
  // ---------------------------------------------------------------------------
  static const Color categoryPersonal = primaryLight;
  static const Color categoryWork = warmBrown;
  static const Color categoryIdeas = secondary;
  static const Color categoryImportant = accent;

  static const Color categoryPersonalTint = Color(0x2638BDF8);
  static const Color categoryWorkTint = Color(0x2678350F);
  static const Color categoryIdeasTint = Color(0x26F59E0B);
  static const Color categoryImportantTint = Color(0x26EF4444);

  // ---------------------------------------------------------------------------
  // Gradients
  // ---------------------------------------------------------------------------
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[background, backgroundTint, backgroundAlt],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[primary, primaryLight],
  );
}
