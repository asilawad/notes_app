import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint, listEquals;
import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:get/get.dart';

import '../app/routes/app_routes.dart';
import '../core/constants/app_durations.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/app_snackbar.dart';
import '../data/models/note_category.dart';
import '../data/models/note_model.dart';
import '../data/repositories/note_repository.dart';

/// Date-range filter options on the home screen.
///
/// Filters by the note's last update time, the same date its tile shows.
enum DateRangeFilter {
  anyTime(label: AppStrings.dateAnyTime),
  today(label: AppStrings.dateToday, windowDays: 1),
  last7Days(label: AppStrings.dateLast7Days, windowDays: 7),
  last30Days(label: AppStrings.dateLast30Days, windowDays: 30);

  const DateRangeFilter({required this.label, this.windowDays});

  /// Display text for the filter chip.
  final String label;

  /// Number of calendar days (including today) the filter covers.
  /// Null means no limit.
  final int? windowDays;

  /// Oldest moment a note may have been updated to pass this filter, or
  /// null when there is no limit.
  DateTime? cutoff(DateTime now) {
    final int? days = windowDays;
    if (days == null) return null;
    return DateTime(now.year, now.month, now.day - (days - 1));
  }
}

/// State and actions of the home screen: live notes stream, debounced search,
/// category and date filters, list/grid toggle, navigation and delete.
class HomeController extends GetxController {
  HomeController({NoteRepository? repository})
    : _repository = repository ?? Get.find<NoteRepository>();

  final NoteRepository _repository;

  /// Owned here so filters can be cleared from anywhere. The view passes it
  /// to `SearchBarField` together with [onSearchChanged].
  final TextEditingController searchController = TextEditingController();

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------
  final RxList<NoteModel> _notes = <NoteModel>[].obs;

  /// Notes after search, category and date filters. The view renders this.
  final RxList<NoteModel> filteredNotes = <NoteModel>[].obs;

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxBool isRetrying = false.obs;
  final RxBool isGridView = false.obs;

  /// Raw text, updated on every keystroke.
  final RxString searchText = ''.obs;

  /// Debounced query actually used for filtering.
  final RxString searchQuery = ''.obs;

  /// Null means "All".
  final Rxn<NoteCategory> selectedCategory = Rxn<NoteCategory>();
  final Rx<DateRangeFilter> selectedDateFilter = DateRangeFilter.anyTime.obs;

  StreamSubscription<List<NoteModel>>? _subscription;
  final List<Worker> _workers = <Worker>[];

  /// True when at least one note exists, ignoring filters.
  bool get hasNotes => _notes.isNotEmpty;

  /// True when search or any filter is narrowing the list. The view uses it
  /// to choose between the "no notes" and "no results" empty states.
  bool get hasActiveFilters =>
      searchQuery.value.trim().isNotEmpty ||
      selectedCategory.value != null ||
      selectedDateFilter.value != DateRangeFilter.anyTime;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------
  @override
  void onInit() {
    super.onInit();

    _workers
      ..add(
        debounce<String>(
          searchText,
          (String value) => searchQuery.value = value,
          time: AppDurations.searchDebounce,
        ),
      )
      ..add(
        everAll(<RxInterface<dynamic>>[
          _notes,
          searchQuery,
          selectedCategory,
          selectedDateFilter,
        ], (_) => _applyFilters()),
      );

    _subscribeToNotes();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    for (final Worker worker in _workers) {
      worker.dispose();
    }
    searchController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Notes stream
  // ---------------------------------------------------------------------------
  void _subscribeToNotes() {
    _subscription?.cancel();
    _subscription = _repository.watchNotes().listen(
      _onNotesChanged,
      onError: _onStreamError,
    );
  }

  void _onNotesChanged(List<NoteModel> notes) {
    // Firestore emits again when a pending server timestamp is confirmed.
    // Identical lists are skipped, so the UI is not rebuilt for nothing.
    if (!listEquals(_notes, notes)) _notes.assignAll(notes);

    isLoading.value = false;
    hasError.value = false;
    isRetrying.value = false;
  }

  void _onStreamError(Object error, StackTrace stackTrace) {
    debugPrint(error.toString());
    isLoading.value = false;
    isRetrying.value = false;
    hasError.value = true;
  }

  /// Re-subscribes after a failed load (the error view's retry button).
  void retry() {
    isRetrying.value = true;
    _subscribeToNotes();
  }

  // ---------------------------------------------------------------------------
  // Search & filters
  // ---------------------------------------------------------------------------
  /// Forwards every keystroke. Filtering waits for the debounce, except when
  /// the field is emptied, which resets the list immediately.
  void onSearchChanged(String value) {
    searchText.value = value;
    if (value.trim().isEmpty) searchQuery.value = '';
  }

  void selectCategory(NoteCategory? category) =>
      selectedCategory.value = category;

  void selectDateFilter(DateRangeFilter filter) =>
      selectedDateFilter.value = filter;

  /// Resets search, category and date filters at once.
  void clearFilters() {
    searchController.clear();
    searchText.value = '';
    searchQuery.value = '';
    selectedCategory.value = null;
    selectedDateFilter.value = DateRangeFilter.anyTime;
  }

  void toggleLayout() => isGridView.toggle();

  void _applyFilters() {
    final String query = searchQuery.value.trim().toLowerCase();
    final NoteCategory? category = selectedCategory.value;
    final DateTime? cutoff = selectedDateFilter.value.cutoff(DateTime.now());

    filteredNotes.assignAll(
      _notes.where((NoteModel note) {
        if (category != null && note.category != category) return false;
        if (cutoff != null && note.updatedAt.isBefore(cutoff)) return false;
        if (query.isEmpty) return true;
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query);
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------
  /// Opens the details screen. The note is passed as a snapshot so the Hero
  /// transition has content on its first frame; the details screen then
  /// keeps itself live by watching the note's id.
  void openNote(NoteModel note) {
    Get.toNamed<void>(AppRoutes.noteDetail, arguments: note);
  }

  void openNewNote() {
    Get.toNamed<void>(AppRoutes.noteForm);
  }

  // ---------------------------------------------------------------------------
  // Delete & undo
  // ---------------------------------------------------------------------------
  /// Deletes [note] and offers Undo.
  ///
  /// The Undo snackbar is shown right away instead of after the server
  /// confirms. Offline, Firestore applies the delete locally at once but the
  /// write only completes when the connection returns, so waiting would
  /// delay the snackbar indefinitely. A failed delete replaces it with an
  /// error message.
  Future<void> deleteNote(NoteModel note) async {
    final Future<void> pendingDelete = _repository.deleteNote(note.id);

    AppSnackbar.undo(
      message: AppStrings.noteDeleted,
      onUndo: () => restoreNote(note),
    );

    try {
      await pendingDelete;
    } on NoteRepositoryException {
      AppSnackbar.error(AppStrings.deleteError);
    }
  }

  /// Brings back a deleted note with its original id and timestamps.
  Future<void> restoreNote(NoteModel note) async {
    try {
      await _repository.restoreNote(note);
    } on NoteRepositoryException {
      AppSnackbar.error(AppStrings.genericError);
    }
  }
}
