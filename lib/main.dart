import 'package:flutter/material.dart';

import 'app/app.dart';
import 'firebase_options.dart';

/// App entry point.
///
/// Firebase must be initialized before `runApp`: `InitialBinding` creates
/// `NoteService` as soon as `GetMaterialApp` is built, and `NoteService`
/// reads `FirebaseFirestore.instance` on creation.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}