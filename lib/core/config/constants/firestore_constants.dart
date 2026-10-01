/// Central Firestore schema names for the Notes App.
///
/// Collection and field names are defined once here so the service layer and
/// [NoteModel] can never drift out of sync.
abstract final class FirestoreConstants {
  // ---------------------------------------------------------------------------
  // Collections
  // ---------------------------------------------------------------------------
  static const String notesCollection = 'notes';

  // ---------------------------------------------------------------------------
  // Note document fields
  // ---------------------------------------------------------------------------
  static const String fieldTitle = 'title';
  static const String fieldContent = 'content';
  static const String fieldCategory = 'category';
  static const String fieldCreatedAt = 'createdAt';
  static const String fieldUpdatedAt = 'updatedAt';

  // ---------------------------------------------------------------------------
  // Query settings
  // ---------------------------------------------------------------------------
  /// Notes are streamed newest-edited first.
  static const String defaultOrderField = fieldUpdatedAt;
  static const bool defaultOrderDescending = true;
}
