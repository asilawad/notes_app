import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:get/get.dart';

import '../app/routes/app_routes.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/app_snackbar.dart';
import '../data/models/note_model.dart';
import '../data/repositories/note_repository.dart';

/// State and actions of the note details screen.
///
/// The note passed in `Get.arguments` is only the first snapshot (so the
/// Hero transition has content on its first frame). The controller then
/// watches the note by its id, so edits made in the form show up here
/// immediately, with no refetch and no dependency on `HomeController`.
class NoteDetailController extends GetxController {
  NoteDetailController({NoteRepository? repository})
    : _repository = repository ?? Get.find<NoteRepository>();

  final NoteRepository _repository;

  /// The note being displayed. Null only when the screen was opened without
  /// a valid note, in which case the screen closes itself right away.
  final Rxn<NoteModel> note = Rxn<NoteModel>();

  final RxBool hasError = false.obs;
  final RxBool isRetrying = false.obs;

  StreamSubscription<NoteModel?>? _subscription;
  String? _noteId;

  /// Set once this screen starts deleting the note, so the "note no longer
  /// exists" update caused by our own delete is not treated as an error.
  bool _isDeleting = false;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------
  @override
  void onInit() {
    super.onInit();

    final Object? arguments = Get.arguments;
    if (arguments is NoteModel && !arguments.isNew) {
      note.value = arguments;
      _noteId = arguments.id;
      _subscribeToNote();
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Navigation is not safe inside onInit, so an invalid entry closes here.
    if (note.value == null) _handleMissingNote();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Live note
  // ---------------------------------------------------------------------------
  void _subscribeToNote() {
    final String? id = _noteId;
    if (id == null) return;

    _subscription?.cancel();
    _subscription = _repository
        .watchNote(id)
        .listen(_onNoteChanged, onError: _onStreamError);
  }

  void _onNoteChanged(NoteModel? updated) {
    if (_isDeleting) return;

    if (updated == null) {
      _handleMissingNote();
      return;
    }

    // Firestore emits again when a pending server timestamp is confirmed.
    // Identical values are skipped, so the screen is not rebuilt for nothing.
    if (note.value != updated) note.value = updated;

    hasError.value = false;
    isRetrying.value = false;
  }

  void _onStreamError(Object error, StackTrace stackTrace) {
    debugPrint(error.toString());
    isRetrying.value = false;
    hasError.value = true;
  }

  /// The note was deleted elsewhere (or never existed): tell the user and
  /// leave the screen.
  void _handleMissingNote() {
    AppSnackbar.error(AppStrings.noteNotFound);
    Get.back<void>();
  }

  /// Re-subscribes after a failed update (the error view's retry button).
  void retry() {
    isRetrying.value = true;
    _subscribeToNote();
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------
  /// Opens the shared create/edit form in edit mode.
  void editNote() {
    final NoteModel? current = note.value;
    if (current == null) return;
    Get.toNamed<void>(AppRoutes.noteForm, arguments: current);
  }

  /// Deletes the note, returns to the previous screen and offers Undo.
  ///
  /// The view must ask the user to confirm before calling this.
  ///
  /// As in `HomeController.deleteNote`, the Undo snackbar is shown right
  /// away instead of after the server confirms, because offline writes only
  /// complete when the connection returns. A failed delete replaces it with
  /// an error message.
  Future<void> deleteNote() async {
    final NoteModel? current = note.value;
    if (current == null || _isDeleting) return;
    _isDeleting = true;

    final Future<void> pendingDelete = _repository.deleteNote(current.id);

    Get.back<void>();
    AppSnackbar.undo(
      message: AppStrings.noteDeleted,
      onUndo: () => _restoreNote(current),
    );

    try {
      await pendingDelete;
    } on NoteRepositoryException {
      AppSnackbar.error(AppStrings.deleteError);
    }
  }

  /// Runs from the Undo action, possibly after this controller is closed, so
  /// it only touches the repository.
  Future<void> _restoreNote(NoteModel deleted) async {
    try {
      await _repository.restoreNote(deleted);
    } on NoteRepositoryException {
      AppSnackbar.error(AppStrings.genericError);
    }
  }
}
