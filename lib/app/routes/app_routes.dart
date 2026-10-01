/// Named routes of the Notes App.
///
/// Route names are defined once here and used by `AppPages` and by the
/// controllers that navigate, so a path string is never typed twice.
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String noteDetail = '/note-detail';
  static const String noteForm = '/note-form';

  /// Route the app opens first.
  static const String initial = splash;
}
