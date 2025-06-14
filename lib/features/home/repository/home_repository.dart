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
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  EitherUser<UserModel> completeTask(String taskUuid, String userUid) async {
    try {
      final userBox = Hive.box(Constants.userBox);

      final snapshot = await _fireStore.collection('Users').doc(userUid).get();

      final userData = snapshot.data();

      if (userData == null) {
        throw Exception('user not found');
      }

      UserModel user = UserModel.fromMap(userData);
      late TaskModel completedTask;

      List<TaskModel> tasks = user.tasks;

      for (int i = 0; i < tasks.length; i++) {
        if (tasks[i].uuid == taskUuid) {
          //finds the task
          TaskModel task = tasks[i];
          completedTask = task.copyWith(
              isCompleted:
                  true); // new task set with the same fields but isCompleted is set to true
          tasks[i] = completedTask; // new task is inserted at the index
        }
      }
      user.tasks = tasks;

      await userBox.put(Constants.boxKey, user);

      await _fireStore
          .collection(Constants.userCollection)
          .doc(userUid)
          .update({'tasks': user.tasks.map((task) => task.toMap()).toList()});

      return right(user);
    } catch (e) {
      return left(Failure(e.toString()!));
    }
  }

  EitherUser<UserModel> removeCompleted(String taskUuid, String userUid) async {
    try {
      final userBox = Hive.box(Constants.userBox);

      final snapshot = await _fireStore.collection('Users').doc(userUid).get();

      final userData = snapshot.data();

      if (userData == null) {
        throw Exception('user not found');
      }

      UserModel user = UserModel.fromMap(userData);
      late TaskModel pendingTask;

      List<TaskModel> tasks = user.tasks;

      for (int i = 0; i < tasks.length; i++) {
        if (tasks[i].uuid == taskUuid) {
          //finds the task
          TaskModel pendingTask = tasks[i];
          pendingTask = tasks[i].copyWith(isCompleted: false);
          tasks[i] = pendingTask; // new task is inserted at the index
        }
      }
      user.tasks = tasks;

      await userBox.put(Constants.boxKey, user);

      await _fireStore
          .collection(Constants.userCollection)
          .doc(userUid)
          .update({'tasks': user.tasks.map((task) => task.toMap()).toList()});

      return right(user);
    } catch (e, stack) {
      print(stack);
      return left(Failure(e.toString()));
    }
  }

  EitherUser<UserModel> updateTask(
      String taskUuid, String userUid, TaskModel updatedTask) async {
    try {
      final userBox = Hive.box(Constants.userBox);

      final snapshot = await _fireStore.collection('Users').doc(userUid).get();

      final userData = snapshot.data();

      if (userData == null) {
        throw Exception('user not found');
      }

      UserModel user = UserModel.fromMap(userData);

      for (int i = 0; i < user.tasks.length; i++) {
        if (user.tasks[i].uuid == taskUuid) {
          user.tasks[i] = updatedTask;
        }
      }
      userBox.put(Constants.boxKey, user);
      await _fireStore
          .collection(Constants.userCollection)
          .doc(userUid)
          .update({'tasks': user.tasks.map((task) => task.toMap()).toList()});

      return right(user);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  EitherUser<UserModel> deleteTask(
    String taskUuid,
    String userUid,
  ) async {
    try {
      final userBox = Hive.box(Constants.userBox);

      final snapshot = await _fireStore.collection('Users').doc(userUid).get();

      final userData = snapshot.data();

      if (userData == null) {
        throw Exception('user not found');
      }

      UserModel user = UserModel.fromMap(userData);

      user.tasks = user.tasks.where((task) => task.uuid != taskUuid).toList();

      userBox.put(Constants.boxKey, user);

      await _fireStore
          .collection(Constants.userCollection)
          .doc(userUid)
          .update({'tasks': user.tasks.map((task) => task.toMap()).toList()});

      return right(user);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
