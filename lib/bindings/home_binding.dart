import 'package:get/get.dart';

import '../controllers/home_controller.dart';

/// Registers the controller for the home screen.
///
/// Used by the home route in `app_pages.dart`. `lazyPut` creates the
/// controller on first use, and GetX removes it when the home route is
/// removed from the navigation stack. The repository it needs is already
/// registered by `InitialBinding`, so nothing else is required here.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(HomeController.new);
  }
}
