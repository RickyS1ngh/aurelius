import 'package:aurelius/core/constants/constants.dart';
import 'package:aurelius/core/failure.dart';
import 'package:aurelius/core/providers/firebase_providers.dart';
import 'package:aurelius/core/typedef.dart';
import 'package:aurelius/models/task.dart';
import 'package:aurelius/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_ce/hive.dart';

final homeRepositoryProvider =
    Provider((ref) => HomeRepository(ref.read(firestoreProvider)));

class HomeRepository {
  const HomeRepository(FirebaseFirestore firestore) : _fireStore = firestore;
  final FirebaseFirestore _fireStore;

  EitherUser<UserModel> addTask(String uid, TaskModel task) async {
    try {
      final userBox = Hive.box(Constants.userBox);

      final snapshot = await _fireStore.collection('Users').doc(uid).get();

      final userData = snapshot.data();

      if (userData == null) {
        throw Exception('user not found');
      }

      UserModel user = UserModel.fromMap(userData);

      user.tasks.add(task);

      await _fireStore
          .collection(Constants.userCollection)
          .doc(uid)
          .update({'tasks': user.tasks.map((task) => task.toMap()).toList()});
      await userBox.put(Constants.boxKey, user);

      return right(userBox.get(Constants.boxKey));
    } catch (e, stack) {
      print(stack);
      return left(Failure(e.toString()));
    }
  }
}
