import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/splash_controller.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/responsive/responsive.dart';
import '../widgets/gradient_background.dart';

/// Initial screen: the logo scales and fades in over the soft gradient
/// backdrop, then `SplashController` opens the home screen.
///
/// The view is stateless. The animation and the navigation timer live in
/// [SplashController]; this widget only listens to its `fade` and `scale`.
class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double logoSize = context.scale(AppDimensions.splashLogoSize);

    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: FadeTransition(
            opacity: controller.fade,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ScaleTransition(
                  scale: controller.scale,
                  child: ExcludeSemantics(
                    child: Image.asset(
                      AppAssets.appLogo,
                      width: logoSize,
                      height: logoSize,
                      fit: BoxFit.contain,
                      errorBuilder: (BuildContext context, Object error, _) {
                        return _FallbackLogo(size: logoSize);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLg),
                Text(
                  AppStrings.appName,
                  textAlign: TextAlign.center,
                  style: textTheme.displayLarge,
                ),
                const SizedBox(height: AppDimensions.spaceXs),
                Padding(
                  padding: AppDimensions.screenPadding,
                  child: Text(
                    AppStrings.splashTagline,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Gradient circle with a note icon, shown when the logo file is missing
/// from `assets/images/`, so the splash never shows a broken image.
class _FallbackLogo extends StatelessWidget {
  const _FallbackLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
      ),
      child: const Icon(
        Icons.sticky_note_2_rounded,
        size: AppDimensions.splashFallbackIconSize,
        color: AppColors.textOnPrimary,
      ),
    );
  }
}
