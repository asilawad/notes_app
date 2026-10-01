/// Central text resource for the Notes App.
///
/// Every user-facing string must be defined here. Strings that need runtime
/// values are exposed as static functions so views never build text manually.
abstract final class AppStrings {
  // ---------------------------------------------------------------------------
  // App
  // ---------------------------------------------------------------------------
  static const String appName = 'Notes';
  static const String splashTagline = 'Capture ideas. Stay organized.';

  // ---------------------------------------------------------------------------
  // Home
  // ---------------------------------------------------------------------------
  static const String homeTitle = 'My Notes';
  static const String searchHint = 'Search notes...';
  static String notesCount(int count) => count == 1 ? '1 note' : '$count notes';

  // ---------------------------------------------------------------------------
  // Filters
  // ---------------------------------------------------------------------------
  static const String categoryAll = 'All';
  static const String dateAnyTime = 'Any time';
  static const String dateToday = 'Today';
  static const String dateLast7Days = 'Last 7 days';
  static const String dateLast30Days = 'Last 30 days';

  // ---------------------------------------------------------------------------
  // Categories
  // ---------------------------------------------------------------------------
  static const String categoryPersonal = 'Personal';
  static const String categoryWork = 'Work';
  static const String categoryIdeas = 'Ideas';
  static const String categoryImportant = 'Important';
  static const String categoryLabel = 'Category';

  // ---------------------------------------------------------------------------
  // Empty & no-results states
  // ---------------------------------------------------------------------------
  static const String emptyTitle = 'No notes yet';
  static const String emptyMessage =
      'Tap the button below to write your first note.';
  static const String noResultsTitle = 'No matching notes';
  static const String noResultsMessage =
      'Try a different search or clear your filters.';
  static const String clearFilters = 'Clear filters';

  // ---------------------------------------------------------------------------
  // Note form (create & edit)
  // ---------------------------------------------------------------------------
  static const String createNoteTitle = 'New Note';
  static const String editNoteTitle = 'Edit Note';
  static const String titleHint = 'Title';
  static const String contentHint = 'Start writing...';
  static const String saveNote = 'Save';
  static const String updateNote = 'Update';
  static const String cancel = 'Cancel';

  // ---------------------------------------------------------------------------
  // Note details
  // ---------------------------------------------------------------------------
  static const String detailsTitle = 'Note';
  static const String untitledNote = 'Untitled';
  static String createdOn(String date) => 'Created $date';
  static String updatedOn(String date) => 'Updated $date';

  // ---------------------------------------------------------------------------
  // Relative dates
  // ---------------------------------------------------------------------------
  static const String justNow = 'Just now';
  static const String yesterday = 'Yesterday';
  static String minutesAgo(int minutes) => '$minutes min ago';
  static String hoursAgo(int hours) =>
      hours == 1 ? '1 hour ago' : '$hours hours ago';
  static String daysAgo(int days) => '$days days ago';

  // ---------------------------------------------------------------------------
  // Delete
  // ---------------------------------------------------------------------------
  static const String deleteDialogTitle = 'Delete note?';
  static const String deleteDialogMessage =
      'This note will be permanently removed.';
  static const String deleteConfirm = 'Delete';
  static const String undo = 'Undo';

  // ---------------------------------------------------------------------------
  // Validation
  // ---------------------------------------------------------------------------
  static const String titleRequired = 'Please enter a title';
  static const String contentRequired = 'Please write something';
  static String titleTooLong(int maxLength) =>
      'Title must be $maxLength characters or less';
  static String contentTooLong(int maxLength) =>
      'Note must be $maxLength characters or less';

  // ---------------------------------------------------------------------------
  // Feedback messages
  // ---------------------------------------------------------------------------
  static const String noteCreated = 'Note saved';
  static const String noteUpdated = 'Note updated';
  static const String noteDeleted = 'Note deleted';
  static const String successTitle = 'Success';
  static const String errorTitle = 'Something went wrong';
  static const String genericError = 'Something went wrong. Please try again.';
  static const String loadError = 'We could not load your notes.';
  static const String saveError = 'We could not save your note.';
  static const String deleteError = 'We could not delete your note.';
  static const String noteNotFound = 'This note no longer exists.';
  static const String retry = 'Try again';

  // ---------------------------------------------------------------------------
  // Tooltips & semantics
  // ---------------------------------------------------------------------------
  static const String tooltipAddNote = 'Add note';
  static const String tooltipBack = 'Back';
  static const String tooltipEdit = 'Edit note';
  static const String tooltipDelete = 'Delete note';
  static const String tooltipClearSearch = 'Clear search';
  static const String tooltipGridView = 'Grid view';
  static const String tooltipListView = 'List view';
}
