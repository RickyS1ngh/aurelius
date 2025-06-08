// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uuid/uuid.dart';

class ReflectionModel {
  final String title;
  final String text;
  final String uuid;
  DateTime createdAt;
  ReflectionModel({
    required this.title,
    required this.text,
    String? uuid,
    DateTime? createdAt,
  })  : uuid = uuid ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  ReflectionModel copyWith({
    String? title,
    String? text,
    String? uuid,
    DateTime? createdAt,
  }) {
    return ReflectionModel(
      title: title ?? this.title,
      text: text ?? this.text,
      uuid: uuid ?? this.uuid,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'text': text,
      'uuid': uuid,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ReflectionModel.fromMap(Map<String, dynamic> map) {
    return ReflectionModel(
      title: map['title'] as String,
      text: map['text'] as String,
      uuid: map['uuid'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReflectionModel.fromJson(String source) =>
      ReflectionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReflectionModel(title: $title, text: $text, uuid: $uuid, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ReflectionModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.text == text &&
        other.uuid == uuid &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return title.hashCode ^ text.hashCode ^ uuid.hashCode ^ createdAt.hashCode;
  }
}
