import 'package:get/get.dart';

import '../controllers/note_detail_controller.dart';

/// Registers the controller for the note details screen.
///
/// Used by the note detail route in `app_pages.dart`. `lazyPut` creates the
/// controller when the screen first asks for it, at which point
/// `Get.arguments` already holds the note passed by `HomeController.openNote`.
/// GetX removes the controller when the route is popped, so every opened note
/// gets a fresh controller and its stream subscription is cancelled in
/// `onClose`. The repository it needs is already registered by
/// `InitialBinding`.
class NoteDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoteDetailController>(NoteDetailController.new);
  }
}
