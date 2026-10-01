import '../models/note_model.dart';

/// Error raised by any [NoteRepository] operation.
///
/// Implementations wrap backend-specific errors (for example Firebase ones)
/// in this type, so controllers never depend on a particular backend.
class NoteRepositoryException implements Exception {
  const NoteRepositoryException(this.cause);

  /// The original error, kept for logging and debugging.
  final Object cause;

  @override
  String toString() => 'NoteRepositoryException: $cause';
}

/// Contract for note persistence.
///
/// Controllers depend on this interface only, so the backend can be swapped
/// or mocked in tests without touching any controller or view.
abstract interface class NoteRepository {
  /// Live list of all notes, ordered newest-edited first.
  Stream<List<NoteModel>> watchNotes();

  /// Live view of a single note. Emits `null` when the note does not exist
  /// (for example after it was deleted).
  Stream<NoteModel?> watchNote(String id);

  /// Saves a new note and returns the id assigned to it.
  Future<String> createNote(NoteModel note);

  /// Updates the editable fields of an existing note.
  Future<void> updateNote(NoteModel note);

  /// Permanently deletes the note with the given [id].
  Future<void> deleteNote(String id);

  /// Re-creates a deleted [note] with its original id and timestamps (Undo).
  Future<void> restoreNote(NoteModel note);
}
