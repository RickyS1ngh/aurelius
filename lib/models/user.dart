// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:aurelius/models/task.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  final String username;
  @HiveField(1)
  final String uid;
  @HiveField(2)
  final String email;
  @HiveField(3)
  List<TaskModel> tasks;
  UserModel({
    required this.username,
    String? uid,
    required this.email,
    required this.tasks,
  }) : uid = uid ?? const Uuid().v4();

  UserModel copyWith({
    String? username,
    String? uuid,
    String? email,
    List<TaskModel>? tasks,
  }) {
    return UserModel(
      username: username ?? this.username,
      uid: uuid ?? this.uid,
      email: email ?? this.email,
      tasks: tasks ?? this.tasks,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'uid': uid,
      'email': email,
      'tasks': tasks.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] as String? ?? '',
      uid: map['uid'] as String? ?? '',
      email: map['email'] as String? ?? '',
      tasks: map['tasks'] != null
          ? List<TaskModel>.from(
              (map['tasks'] as List).map<TaskModel>(
                (x) => TaskModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(username: $username, uid: $uid, email: $email, tasks: $tasks)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.uid == uid &&
        other.email == email &&
        listEquals(other.tasks, tasks);
  }

  @override
  int get hashCode {
    return username.hashCode ^ uid.hashCode ^ email.hashCode ^ tasks.hashCode;
  }
}
