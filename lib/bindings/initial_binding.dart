import 'package:get/get.dart';

import '../data/repositories/note_repository.dart';
import '../data/services/note_service.dart';

/// App-wide dependencies, registered once when the app starts.
///
/// Passed to `GetMaterialApp(initialBinding: InitialBinding())`.
///
/// The repository is registered under its interface type
/// ([NoteRepository]), so every controller depends on the abstraction only
/// and never on [NoteService] or Firebase. `permanent: true` keeps it alive
/// for the whole app session, so it is never removed when a screen closes.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NoteRepository>(NoteService(), permanent: true);
  }
}
