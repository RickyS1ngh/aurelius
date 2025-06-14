// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

enum Category { wisdom, discipline, courage }

@HiveType(typeId: 5)
class TaskModel {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final Category category;
  @HiveField(3)
  final DateTime dueDate;
  @HiveField(4)
  final TimeOfDay dueTime;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final bool isCompleted;
  @HiveField(7)
  final String uuid;
  TaskModel(
      {required this.title,
      required this.description,
      required this.category,
      required this.dueDate,
      required this.dueTime,
      DateTime? createdAt,
      bool? isCompleted,
      String? uuid})
      : isCompleted = isCompleted ?? false,
        uuid = uuid ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  TaskModel copyWith({
    String? title,
    String? description,
    Category? category,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    DateTime? createdAt,
    bool? isCompleted,
    String? uuid,
  }) {
    return TaskModel(
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      uuid: uuid ?? this.uuid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'category': category.name,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'dueTime': {'hour': dueTime.hour, 'minute': dueTime.minute},
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'uuid': uuid,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      title: map['title'] as String,
      description: map['description'] as String,
      category: Category.values.firstWhere((e) => e.name == map['category']),
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int),
      dueTime: TimeOfDay(
          hour: (map['dueTime']['hour'] as num).toInt(),
          minute: (map['dueTime']['minute'] as num).toInt()),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      isCompleted: map['isCompleted'] as bool,
      uuid: map['uuid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Task(title: $title, description: $description, category: $category, dueDate: $dueDate, dueTime: $dueTime, createdAt: $createdAt, isCompleted: $isCompleted, uuid: $uuid)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.description == description &&
        other.category == category &&
        other.dueDate == dueDate &&
        other.dueTime == dueTime &&
        other.createdAt == createdAt &&
        other.isCompleted == isCompleted &&
        other.uuid == uuid;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        category.hashCode ^
        dueDate.hashCode ^
        dueTime.hashCode ^
        createdAt.hashCode ^
        isCompleted.hashCode ^
        uuid.hashCode;
  }
}
