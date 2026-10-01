import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/responsive/responsive.dart';
import 'app_button.dart';

/// Centered empty-state message with an illustration, a title, a message and
/// an optional action button.
///
/// Use the named constructors for the two states of the home screen:
/// - [EmptyStateView.noNotes]: the user has no notes yet.
/// - [EmptyStateView.noResults]: search or filters matched nothing.
///
/// If the illustration file is missing from `assets/images/`, a fallback icon
/// inside a soft circle is shown instead, so the app never crashes or shows
/// a broken image.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.title,
    required this.message,
    required this.imagePath,
    required this.fallbackIcon,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  /// "No notes yet". The floating add button is already on screen, so this
  /// state has no action button of its own.
  const EmptyStateView.noNotes({super.key})
    : title = AppStrings.emptyTitle,
      message = AppStrings.emptyMessage,
      imagePath = AppAssets.emptyNotes,
      fallbackIcon = Icons.sticky_note_2_outlined,
      actionLabel = null,
      actionIcon = null,
      onAction = null;

  /// "No matching notes", with a button that resets search and filters.
  const EmptyStateView.noResults({
    super.key,
    required VoidCallback onClearFilters,
  }) : title = AppStrings.noResultsTitle,
       message = AppStrings.noResultsMessage,
       imagePath = AppAssets.noResults,
       fallbackIcon = Icons.search_off_rounded,
       actionLabel = AppStrings.clearFilters,
       actionIcon = Icons.filter_alt_off_rounded,
       onAction = onClearFilters;

  final String title;
  final String message;

  /// Illustration path from `AppAssets`.
  final String imagePath;

  /// Shown when the illustration cannot be loaded.
  final IconData fallbackIcon;

  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double illustrationSize = context.scale(
      AppDimensions.emptyStateImageSize,
    );

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ExcludeSemantics(
              child: Image.asset(
                imagePath,
                width: illustrationSize,
                height: illustrationSize,
                fit: BoxFit.contain,
                errorBuilder: (BuildContext context, Object error, _) {
                  return _FallbackIllustration(
                    icon: fallbackIcon,
                    size: illustrationSize,
                  );
                },
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: AppDimensions.spaceXs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            if (actionLabel != null && onAction != null) ...<Widget>[
              const SizedBox(height: AppDimensions.spaceXl),
              AppButton(
                label: actionLabel!,
                icon: actionIcon,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Soft circle with a large icon, used when the illustration is missing.
class _FallbackIllustration extends StatelessWidget {
  const _FallbackIllustration({required this.icon, required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.backgroundTint,
      ),
      child: Icon(
        icon,
        size: AppDimensions.emptyStateIconSize,
        color: AppColors.primary,
      ),
    );
  }
}
