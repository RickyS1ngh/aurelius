import 'package:aurelius/core/constants/constants.dart';
import 'package:aurelius/core/failure.dart';
import 'package:aurelius/core/providers/firebase_providers.dart';
import 'package:aurelius/core/typedef.dart';
import 'package:aurelius/models/reflection.dart';

import 'package:aurelius/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_ce/hive.dart';

final reflectionRepostioryProvider =
    Provider((ref) => ReflectionRepostiory(ref.read(firestoreProvider)));

class ReflectionRepostiory {
  const ReflectionRepostiory(FirebaseFirestore firestore)
      : _firestore = firestore;
  final FirebaseFirestore _firestore;

  EitherUser<UserModel> addReflection(
      String title, String text, String uid) async {
    try {
      final userBox = Hive.box(Constants.userBox);
      final snapshot = await _firestore.collection('Users').doc(uid).get();

      final userData = snapshot.data();

      if (userData == null) {
        throw Exception('user not found');
      }

      UserModel user = UserModel.fromMap(userData);

      ReflectionModel reflection = ReflectionModel(title: title, text: text);

      user.reflections.add(reflection);

      await _firestore.collection(Constants.userCollection).doc(uid).update({
        'reflections':
            user.reflections.map((reflection) => reflection.toMap()).toList()
      });
      await userBox.put(Constants.boxKey, user);
      return right(user);
    } on FirebaseException catch (e, stack) {
      print(stack);
      return left(Failure(e.message!));
    }
  }

  EitherUser<UserModel> updateReflection(String reflectionUuid, String userUid,
      ReflectionModel updatedReflection) async {
    try {
      final userBox = Hive.box(Constants.userBox);

      final snapshot = await _firestore.collection('Users').doc(userUid).get();

      final userData = snapshot.data();

      if (userData == null) {
        throw Exception('user not found');
      }

      UserModel user = UserModel.fromMap(userData);

      for (int i = 0; i < user.reflections.length; i++) {
        if (user.reflections[i].uuid == reflectionUuid) {
          user.reflections[i] = updatedReflection;
        }
      }
      userBox.put(Constants.boxKey, user);
      await _firestore
          .collection(Constants.userCollection)
          .doc(userUid)
          .update({
        'reflections':
            user.reflections.map((reflection) => reflection.toMap()).toList()
      });

      return right(user);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  EitherUser<UserModel> deleteReflection(
    String reflectionUuid,
    String userUid,
  ) async {
    try {
      final userBox = Hive.box(Constants.userBox);

      final snapshot = await _firestore.collection('Users').doc(userUid).get();

      final userData = snapshot.data();

      if (userData == null) {
        throw Exception('user not found');
      }

      UserModel user = UserModel.fromMap(userData);

      user.reflections = user.reflections
          .where((reflection) => reflection.uuid != reflectionUuid)
          .toList();

      userBox.put(Constants.boxKey, user);

      await _firestore
          .collection(Constants.userCollection)
          .doc(userUid)
          .update({
        'reflections':
            user.reflections.map((reflection) => reflection.toMap()).toList()
      });

      return right(user);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
