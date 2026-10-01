import 'dart:async';

import 'package:flutter/widgets.dart'
    show FocusManager, FormState, GlobalKey, TextEditingController;
import 'package:get/get.dart';

import '../core/constants/app_durations.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/app_snackbar.dart';
import '../data/models/note_category.dart';
import '../data/models/note_model.dart';
import '../data/repositories/note_repository.dart';

/// State and actions of the create/edit screen.
///
/// One controller serves both modes. If `Get.arguments` holds a saved
/// [NoteModel], the form opens in edit mode with its fields pre-filled;
/// otherwise it opens empty, in create mode.
class NoteFormController extends GetxController {
  NoteFormController({NoteRepository? repository})
    : _repository = repository ?? Get.find<NoteRepository>();

  final NoteRepository _repository;

  /// Validates every field at once. Each field's own validator
  /// (`Validators.title` and `Validators.content`) is set in the view.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  final Rx<NoteCategory> selectedCategory = NoteCategory.defaultCategory.obs;

  /// True while a save is in progress. The view disables the fields and
  /// shows the loading state on the save button.
  final RxBool isSaving = false.obs;

  /// The note being edited, or null in create mode.
  NoteModel? _original;

  bool get isEditing => _original != null;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------
  @override
  void onInit() {
    super.onInit();

    final Object? arguments = Get.arguments;
    if (arguments is NoteModel && !arguments.isNew) {
      _original = arguments;
      titleController.text = arguments.title;
      contentController.text = arguments.content;
      selectedCategory.value = arguments.category;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------
  void selectCategory(NoteCategory category) =>
      selectedCategory.value = category;

  void cancel() => Get.back<void>();

  /// Validates the form and saves the note (create or update).
  ///
  /// Offline, Firestore applies a write locally at once but its Future only
  /// completes when the server confirms. So the screen does not wait forever:
  /// after [AppDurations.saveTimeout] the save is treated as queued locally
  /// and the screen closes, while a late failure is still reported.
  Future<void> save() async {
    if (isSaving.value) return;
    if (!(formKey.currentState?.validate() ?? false)) return;

    // Values are trimmed here because the validators compare trimmed text.
    final String title = titleController.text.trim();
    final String content = contentController.text.trim();
    final NoteCategory category = selectedCategory.value;

    final NoteModel? original = _original;
    if (original != null &&
        original.title == title &&
        original.content == content &&
        original.category == category) {
      // Nothing changed: leave without a write, so `updatedAt` is not
      // bumped and the note does not jump to the top of the list.
      Get.back<void>();
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    isSaving.value = true;

    final Future<void> pendingSave = original == null
        ? _repository
              .createNote(
                NoteModel.draft(
                  title: title,
                  content: content,
                  category: category,
                ),
              )
              .then<void>((String _) {})
        : _repository.updateNote(
            original.copyWith(
              title: title,
              content: content,
              category: category,
            ),
          );

    try {
      await pendingSave.timeout(AppDurations.saveTimeout);
    } on TimeoutException {
      // Most likely offline: the write is queued locally. If it later fails,
      // the user is told, since the screen is already closed by then.
      unawaited(
        pendingSave.catchError((Object _) {
          AppSnackbar.error(AppStrings.saveError);
        }),
      );
    } on NoteRepositoryException {
      isSaving.value = false;
      AppSnackbar.error(AppStrings.saveError);
      return;
    } catch (_) {
      isSaving.value = false;
      AppSnackbar.error(AppStrings.genericError);
      return;
    }

    AppSnackbar.success(
      isEditing ? AppStrings.noteUpdated : AppStrings.noteCreated,
    );

    // The user may have left the screen while the save was running. Popping
    // again would close the wrong screen, so only pop if still open.
    if (!isClosed) Get.back<void>();
  }
}
