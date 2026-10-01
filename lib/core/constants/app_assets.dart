/// Central asset path registry for the Notes App.
///
/// Every asset path used in the UI must be defined here.
/// Remember to declare the `assets/images/` folder in `pubspec.yaml`.
abstract final class AppAssets {
  static const String _imagesDir = 'assets/images';

  // ---------------------------------------------------------------------------
  // Branding
  // ---------------------------------------------------------------------------
  /// App logo shown on the splash screen.
  static const String appLogo = '$_imagesDir/app_logo.png';

  // ---------------------------------------------------------------------------
  // Illustrations
  // ---------------------------------------------------------------------------
  /// Shown when the user has no notes yet.
  static const String emptyNotes = '$_imagesDir/empty_notes.png';

  /// Shown when search or filters return no results.
  static const String noResults = '$_imagesDir/no_results.png';
}
