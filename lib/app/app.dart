import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bindings/initial_binding.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/app_snackbar.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

/// Root widget of the Notes App.
///
/// Wires together the theme, the routes, the app-wide dependencies and the
/// global snackbar messenger.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.initial,
      getPages: AppPages.pages,
      scaffoldMessengerKey: AppSnackbar.messengerKey,
    );
  }
}
