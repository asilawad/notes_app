import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_durations.dart';
import '../../core/constants/app_sizes.dart';

/// Visual style of an [AppButton].
enum AppButtonVariant {
  /// Filled sky-blue button for the main action (Save, Update).
  primary,

  /// Text-only button for secondary actions (Cancel).
  secondary,

  /// Filled crimson button for destructive actions (Delete).
  danger,
}

/// Reusable app button with a loading state, optional icon and variants.
///
/// Colors, radius, padding and text style come from the button themes in
/// `AppTheme`; this widget only adds the loading state and the variants.
/// While [isLoading] is true the button keeps its look, shows a spinner and
/// ignores taps, so a form can never be submitted twice.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  });

  final String label;

  /// Pass null to show the button as disabled.
  final VoidCallback? onPressed;

  final AppButtonVariant variant;

  final IconData? icon;

  final bool isLoading;

  /// Stretches the button to the available width.
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? effectiveOnPressed = isLoading ? null : onPressed;

    return switch (variant) {
      AppButtonVariant.primary => ElevatedButton(
        onPressed: effectiveOnPressed,
        style: _filledStyle(),
        child: _buildContent(AppColors.textOnPrimary),
      ),
      AppButtonVariant.danger => ElevatedButton(
        onPressed: effectiveOnPressed,
        style: _filledStyle(background: AppColors.accent),
        child: _buildContent(AppColors.textOnPrimary),
      ),
      AppButtonVariant.secondary => TextButton(
        onPressed: effectiveOnPressed,
        style: _textStyle(),
        child: _buildContent(AppColors.primary),
      ),
    };
  }

  /// Keeps the button colors while loading, instead of the greyed-out
  /// disabled look. A button disabled by a null [onPressed] keeps the
  /// default disabled look.
  ButtonStyle _filledStyle({Color? background}) {
    return ElevatedButton.styleFrom(
      backgroundColor: background,
      disabledBackgroundColor: isLoading
          ? (background ?? AppColors.primary)
          : null,
      disabledForegroundColor: isLoading ? AppColors.textOnPrimary : null,
      minimumSize: fullWidth
          ? const Size(double.infinity, AppDimensions.buttonHeight)
          : null,
    );
  }

  ButtonStyle _textStyle() {
    return TextButton.styleFrom(
      disabledForegroundColor: isLoading ? AppColors.primary : null,
      padding: AppDimensions.buttonPadding,
      minimumSize: Size(
        fullWidth ? double.infinity : AppDimensions.buttonMinWidth,
        AppDimensions.buttonHeight,
      ),
    );
  }

  Widget _buildContent(Color foreground) {
    return AnimatedSwitcher(
      duration: AppDurations.fadeSwitcher,
      child: isLoading
          ? SizedBox(
              key: const ValueKey<bool>(true),
              width: AppDimensions.progressIndicatorSize,
              height: AppDimensions.progressIndicatorSize,
              child: CircularProgressIndicator(
                strokeWidth: AppDimensions.progressIndicatorStroke,
                color: foreground,
              ),
            )
          : Row(
              key: const ValueKey<bool>(false),
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Icon(icon, size: AppDimensions.iconSm),
                  const SizedBox(width: AppDimensions.spaceXs),
                ],
                Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
              ],
            ),
    );
  }
}
