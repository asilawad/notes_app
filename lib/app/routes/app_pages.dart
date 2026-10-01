import 'package:get/get.dart';

import '../../bindings/home_binding.dart';
import '../../bindings/note_detail_binding.dart';
import '../../bindings/note_form_binding.dart';
import '../../controllers/splash_controller.dart';
import '../../core/constants/app_durations.dart';
import '../../views/ui/home_view.dart';
import '../../views/ui/note_detail_view.dart';
import '../../views/ui/note_form_view.dart';
import '../../views/ui/splash_view.dart';
import 'app_routes.dart';

/// Connects every route name to its screen, binding and transition.
///
/// Passed to `GetMaterialApp(getPages: AppPages.pages)`.
abstract final class AppPages {
  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    // The plan has no `splash_binding.dart`, so the splash controller is
    // registered inline. It is created when the screen opens and removed
    // when the route is replaced by home.
    GetPage<dynamic>(
      name: AppRoutes.splash,
      page: SplashView.new,
      binding: BindingsBuilder<dynamic>(() {
        Get.lazyPut<SplashController>(SplashController.new);
      }),
      transition: Transition.fadeIn,
      transitionDuration: AppDurations.pageTransition,
      curve: AppCurves.entrance,
    ),
    GetPage<dynamic>(
      name: AppRoutes.home,
      page: HomeView.new,
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: AppDurations.pageTransition,
      curve: AppCurves.entrance,
    ),
    // The Hero flight between a note tile and this screen lasts as long as
    // the route transition, so it uses the dedicated hero duration.
    GetPage<dynamic>(
      name: AppRoutes.noteDetail,
      page: NoteDetailView.new,
      binding: NoteDetailBinding(),
      transition: Transition.fadeIn,
      transitionDuration: AppDurations.heroTransition,
      curve: AppCurves.entrance,
    ),
    GetPage<dynamic>(
      name: AppRoutes.noteForm,
      page: NoteFormView.new,
      binding: NoteFormBinding(),
      transition: Transition.downToUp,
      transitionDuration: AppDurations.pageTransition,
      curve: AppCurves.entrance,
    ),
  ];
}
