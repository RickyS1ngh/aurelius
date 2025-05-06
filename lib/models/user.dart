// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  final String username;
  @HiveField(1)
  final String uid;
  @HiveField(2)
  final String email;
  UserModel({
    required this.username,
    required this.uid,
    required this.email,
  });

  UserModel copyWith({
    String? username,
    String? uid,
    String? email,
  }) {
    return UserModel(
      username: username ?? this.username,
      uid: uid ?? this.uid,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'uid': uid,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] as String,
      uid: map['uid'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'User(username: $username, uid: $uid, email: $email)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.uid == uid &&
        other.email == email;
  }

  @override
  int get hashCode => username.hashCode ^ uid.hashCode ^ email.hashCode;
}
