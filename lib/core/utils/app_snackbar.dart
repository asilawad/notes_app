import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_durations.dart';
import '../constants/app_strings.dart';

/// Single place for all snackbar feedback in the Notes App.
///
/// Uses a global [ScaffoldMessengerState] key, so feedback can be shown from
/// controllers without a `BuildContext`, and it stays visible while the user
/// navigates back from the form or details screen. Styling (floating
/// behavior, colors, radius) comes from `SnackBarTheme` in `AppTheme`.
abstract final class AppSnackbar {
  /// Must be passed to `GetMaterialApp(scaffoldMessengerKey: ...)`.
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Confirms a successful action, for example "Note saved".
  static void success(String message) {
    _show(
      message: message,
      icon: Icons.check_circle_outline_rounded,
      iconColor: AppColors.primaryLight,
      duration: AppDurations.snackbar,
    );
  }

  /// Reports a failure, for example "We could not save your note.".
  static void error(String message) {
    _show(
      message: message,
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.accent,
      duration: AppDurations.snackbar,
    );
  }

  /// Confirms a deletion and offers an Undo action.
  static void undo({required String message, required VoidCallback onUndo}) {
    _show(
      message: message,
      icon: Icons.delete_outline_rounded,
      iconColor: AppColors.secondary,
      duration: AppDurations.undoSnackbar,
      action: SnackBarAction(label: AppStrings.undo, onPressed: onUndo),
    );
  }

  static void _show({
    required String message,
    required IconData icon,
    required Color iconColor,
    required Duration duration,
    SnackBarAction? action,
  }) {
    final ScaffoldMessengerState? messenger = messengerKey.currentState;
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          action: action,
          content: Row(
            children: <Widget>[
              Icon(icon, color: iconColor, size: AppDimensions.iconSm),
              const SizedBox(width: AppDimensions.spaceXs),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }
}
