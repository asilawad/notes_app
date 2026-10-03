import 'package:flutter/material.dart';
import 'package:notes_app/core/constants/app_colors.dart';
import 'package:notes_app/core/constants/app_sizes.dart';
import 'package:notes_app/core/theme/glass_theme.dart';

/// Visual tone of a [GlassIconButton].
enum GlassIconButtonTone { primary, danger }

/// Round glass icon button for app bars: translucent fill, soft border and
/// shadow. Use [GlassIconButtonTone.danger] for destructive actions.
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.tone = GlassIconButtonTone.primary,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  /// Must come from `AppStrings`.
  final String tooltip;

  final GlassIconButtonTone tone;

  @override
  Widget build(BuildContext context) {
    final bool isDanger = tone == GlassIconButtonTone.danger;
    final Color fill = isDanger
        ? AppColors.errorTint
        : AppColors.glassFillStrong;
    final Color border = isDanger
        ? AppColors.errorBorder
        : AppColors.glassBorderStrong;
    final Color iconColor = isDanger ? AppColors.accent : AppColors.primary;

    return Tooltip(
      message: tooltip,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          shape: BoxShape.circle,
          border: Border.all(
            color: border,
            width: AppDimensions.glassBorderWidth,
          ),
          boxShadow: <BoxShadow>[context.glass.boxShadow],
        ),
        child: ClipOval(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onPressed,
              child: SizedBox(
                width: AppDimensions.iconButtonSize,
                height: AppDimensions.iconButtonSize,
                child: Center(
                  child: Icon(
                    icon,
                    size: AppDimensions.iconButtonIconSize,
                    color: iconColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
