// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ui_stuffs/sqflite_demo/note_fields.dart';

class NoteModel {
  final int? id;
  final int? number;
  final String title;
  final String content;
  final bool isFavorite;
  final DateTime? createdTime;
  NoteModel({
    this.id,
    this.number,
    required this.title,
    required this.content,
    this.isFavorite = false,
    this.createdTime,
  });

  NoteModel copy({
    int? id,
    int? number,
    String? title,
    String? content,
    bool? isFavorite,
    DateTime? createdTime,
  }) =>
      NoteModel(
        id: id ?? this.id,
        number: number ?? this.number,
        title: title ?? this.title,
        content: content ?? this.content,
        isFavorite: isFavorite ?? this.isFavorite,
        createdTime: createdTime ?? this.createdTime,
      );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.number: number,
        NoteFields.title: title,
        NoteFields.content: content,
        NoteFields.isFavorite: isFavorite ? 1 : 0,
        NoteFields.createdTime: createdTime?.toIso8601String(),
      };

  factory NoteModel.fromJson(Map<String, Object?> json) => NoteModel(
        id: json[NoteFields.id] as int?,
        number: json[NoteFields.number] as int?,
        title: json[NoteFields.title] as String,
        content: json[NoteFields.content] as String,
        isFavorite: json[NoteFields.isFavorite] == 1,
        createdTime:
            DateTime.tryParse(json[NoteFields.createdTime] as String? ?? ''),
      );

  @override
  String toString() {
    return 'NoteModel(id: $id, number: $number, title: $title, content: $content, isFavorite: $isFavorite, createdTime: $createdTime)';
  }
}
