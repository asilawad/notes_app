import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants/firestore_constants.dart';
import 'note_category.dart';

/// Immutable note entity with Firestore serialization.
@immutable
class NoteModel {
  const NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a not-yet-saved note. The [id] is assigned by Firestore on save,
  /// and the timestamps are placeholders (the server sets the real values).
  factory NoteModel.draft({
    required String title,
    required String content,
    NoteCategory category = NoteCategory.defaultCategory,
  }) {
    final DateTime now = DateTime.now();
    return NoteModel(
      id: '',
      title: title,
      content: content,
      category: category,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Builds a note from a Firestore document snapshot.
  factory NoteModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return NoteModel.fromMap(doc.id, doc.data() ?? <String, dynamic>{});
  }

  /// Builds a note from a raw map. Every field is read defensively, so a
  /// missing or malformed field in an old document never crashes the app.
  ///
  /// A null timestamp means the server value is still pending (offline write
  /// or latency compensation), so the local time is used until it arrives.
  factory NoteModel.fromMap(String id, Map<String, dynamic> map) {
    final DateTime createdAt =
        _parseDate(map[FirestoreConstants.fieldCreatedAt]) ?? DateTime.now();
    final DateTime updatedAt =
        _parseDate(map[FirestoreConstants.fieldUpdatedAt]) ?? createdAt;

    return NoteModel(
      id: id,
      title: map[FirestoreConstants.fieldTitle]?.toString() ?? '',
      content: map[FirestoreConstants.fieldContent]?.toString() ?? '',
      category: NoteCategory.fromKey(
        map[FirestoreConstants.fieldCategory]?.toString(),
      ),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  final String id;
  final String title;
  final String content;
  final NoteCategory category;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// True for a note that has not been saved to Firestore yet.
  bool get isNew => id.isEmpty;

  /// Shared Hero tag between the list tile and the details screen.
  String get heroTag => 'note-$id';

  /// Fields written when a note is created. Both timestamps are set by the
  /// server, so device clock drift never affects ordering.
  Map<String, dynamic> toCreateMap() {
    return <String, dynamic>{
      FirestoreConstants.fieldTitle: title,
      FirestoreConstants.fieldContent: content,
      FirestoreConstants.fieldCategory: category.key,
      FirestoreConstants.fieldCreatedAt: FieldValue.serverTimestamp(),
      FirestoreConstants.fieldUpdatedAt: FieldValue.serverTimestamp(),
    };
  }

  /// Fields written when a note is edited. `createdAt` is never touched.
  Map<String, dynamic> toUpdateMap() {
    return <String, dynamic>{
      FirestoreConstants.fieldTitle: title,
      FirestoreConstants.fieldContent: content,
      FirestoreConstants.fieldCategory: category.key,
      FirestoreConstants.fieldUpdatedAt: FieldValue.serverTimestamp(),
    };
  }

  /// Fields written when a deleted note is restored (Undo). The original
  /// timestamps are kept, so the note returns to its previous position.
  Map<String, dynamic> toRestoreMap() {
    return <String, dynamic>{
      FirestoreConstants.fieldTitle: title,
      FirestoreConstants.fieldContent: content,
      FirestoreConstants.fieldCategory: category.key,
      FirestoreConstants.fieldCreatedAt: Timestamp.fromDate(createdAt),
      FirestoreConstants.fieldUpdatedAt: Timestamp.fromDate(updatedAt),
    };
  }

  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    NoteCategory? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _parseDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NoteModel &&
            other.id == id &&
            other.title == title &&
            other.content == content &&
            other.category == category &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode =>
      Object.hash(id, title, content, category, createdAt, updatedAt);
}
