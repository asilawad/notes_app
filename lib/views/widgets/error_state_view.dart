import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/responsive/responsive.dart';
import 'app_button.dart';

/// Centered error message with an icon and a "Try again" button.
///
/// Use it when loading or a similar operation fails. The [message] must come
/// from `AppStrings` (for example `AppStrings.loadError`), and [onRetry]
/// repeats the failed operation. While [isRetrying] is true the button shows
/// its loading state and ignores taps, so retries cannot be spammed.
///
/// The view is a live region, so screen readers announce the error as soon
/// as it appears.
class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    super.key,
    required this.message,
    required this.onRetry,
    this.title = AppStrings.errorTitle,
    this.isRetrying = false,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;
  final bool isRetrying;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double circleSize = context.scale(AppDimensions.errorStateCircleSize);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceXl),
        child: Semantics(
          liveRegion: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ExcludeSemantics(
                child: Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.errorTint,
                  ),
                  child: const Icon(
                    Icons.cloud_off_rounded,
                    size: AppDimensions.errorStateIconSize,
                    color: AppColors.error,
                  ),
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
              const SizedBox(height: AppDimensions.spaceXl),
              AppButton(
                label: AppStrings.retry,
                icon: Icons.refresh_rounded,
                isLoading: isRetrying,
                onPressed: onRetry,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
