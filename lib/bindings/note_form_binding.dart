import 'package:get/get.dart';

import '../controllers/note_form_controller.dart';

/// Registers the controller for the create/edit note screen.
///
/// Used by the note form route in `app_pages.dart`. `lazyPut` creates the
/// controller when the screen first asks for it, at which point
/// `Get.arguments` already holds either a saved note (edit mode) or nothing
/// (create mode). GetX removes the controller when the route is popped, so
/// every opening of the form starts with fresh fields. The repository it
/// needs is already registered by `InitialBinding`.
class NoteFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoteFormController>(NoteFormController.new);
  }
}
