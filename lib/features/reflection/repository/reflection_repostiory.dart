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
}
