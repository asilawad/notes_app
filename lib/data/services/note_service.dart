import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_constants.dart';
import '../repositories/note_repository.dart';
import '../models/note_model.dart';

/// Firestore implementation of [NoteRepository].
///
/// This is the only class in the app that talks to Cloud Firestore.
/// Firebase errors are wrapped in [NoteRepositoryException], so controllers
/// never depend on Firebase types.
class NoteService implements NoteRepository {
  NoteService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _notes =>
      _firestore.collection(FirestoreConstants.notesCollection);

  @override
  Stream<List<NoteModel>> watchNotes() {
    return _notes
        .orderBy(
          FirestoreConstants.defaultOrderField,
          descending: FirestoreConstants.defaultOrderDescending,
        )
        .snapshots(includeMetadataChanges: true)
        .map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
              .map(NoteModel.fromFirestore)
              .toList(growable: false),
        )
        .transform(_wrapStreamErrors<List<NoteModel>>());
  }

  @override
  Stream<NoteModel?> watchNote(String id) {
    return _notes
        .doc(id)
        .snapshots(includeMetadataChanges: true)
        .map(
          (DocumentSnapshot<Map<String, dynamic>> snapshot) =>
              snapshot.exists ? NoteModel.fromFirestore(snapshot) : null,
        )
        .transform(_wrapStreamErrors<NoteModel?>());
  }

  @override
  Future<String> createNote(NoteModel note) {
    return _guard<String>(() async {
      final DocumentReference<Map<String, dynamic>> reference = await _notes
          .add(note.toCreateMap());
      return reference.id;
    });
  }

  @override
  Future<void> updateNote(NoteModel note) {
    return _guard<void>(() => _notes.doc(note.id).update(note.toUpdateMap()));
  }

  @override
  Future<void> deleteNote(String id) {
    return _guard<void>(() => _notes.doc(id).delete());
  }

  @override
  Future<void> restoreNote(NoteModel note) {
    return _guard<void>(() => _notes.doc(note.id).set(note.toRestoreMap()));
  }

  /// Runs a Firestore write and converts Firebase errors into
  /// [NoteRepositoryException].
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseException catch (error) {
      throw NoteRepositoryException(error);
    }
  }

  /// Converts Firebase errors emitted by a stream into
  /// [NoteRepositoryException]. Other errors pass through unchanged.
  StreamTransformer<T, T> _wrapStreamErrors<T>() {
    return StreamTransformer<T, T>.fromHandlers(
      handleError: (Object error, StackTrace stackTrace, EventSink<T> sink) {
        sink.addError(
          error is FirebaseException ? NoteRepositoryException(error) : error,
          stackTrace,
        );
      },
    );
  }
}
