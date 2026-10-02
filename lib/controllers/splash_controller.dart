import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../app/routes/app_routes.dart';
import '../core/constants/app_durations.dart';
import '../core/constants/app_sizes.dart';

/// Drives the splash screen: plays the logo entry animation, then opens the
/// home screen after [AppDurations.splashTotal].
///
/// The animation lives here (not in the view), so `SplashView` can be a
/// stateless widget that only listens to [fade] and [scale].
class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  /// Opacity of the logo and tagline, from 0 to 1.
  late final Animation<double> fade;

  /// Scale of the logo, from `AppDimensions.splashScaleBegin` to 1.
  late final Animation<double> scale;

  Timer? _navigationTimer;

  @override
  void onInit() {
    super.onInit();

    _animationController = AnimationController(
      vsync: this,
      duration: AppDurations.splashAnimation,
    );

    // The entrance curve never overshoots 1, so it is safe for opacity.
    final Animation<double> curved = CurvedAnimation(
      parent: _animationController,
      curve: AppCurves.entrance,
    );

    fade = curved;
    scale = Tween<double>(
      begin: AppDimensions.splashScaleBegin,
      end: 1,
    ).animate(curved);
  }

  @override
  void onReady() {
    super.onReady();

    // Respect the system "reduce motion" setting: show the logo immediately.
    final bool reduceMotion = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    if (reduceMotion) {
      _animationController.value = 1;
    } else {
      _animationController.forward();
    }

    _navigationTimer = Timer(AppDurations.splashTotal, _openHome);
  }

  void _openHome() {
    if (isClosed) return;
    Get.offNamed(AppRoutes.home);
  }

  @override
  void onClose() {
    _navigationTimer?.cancel();
    _animationController.dispose();
    super.onClose();
  }
}
