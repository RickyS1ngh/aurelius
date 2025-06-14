import 'package:aurelius/core/utils.dart';
import 'package:aurelius/features/auth/controller/auth_controller.dart';
import 'package:aurelius/features/home/repository/home_repository.dart';
import 'package:aurelius/models/task.dart';
import 'package:aurelius/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, UserModel>((ref) {
  return HomeController(ref.read(homeRepositoryProvider), ref);
});

class HomeController extends StateNotifier<UserModel> {
  HomeController(HomeRepository homerepository, Ref ref)
      : _homeRepository = homerepository,
        _ref = ref,
        super(UserModel(email: '', username: '', tasks: [], reflections: []));
  final HomeRepository _homeRepository;
  final Ref _ref;

  Future<bool> addTask(BuildContext context, String uid, TaskModel task) async {
    final user = await _homeRepository.addTask(uid, task);

    return user.fold((l) {
      showSnackbar(context, l.errorMessage);
      return false;
    }, (user) {
      _ref.read(currentUserProvider.notifier).state = user;
      return true;
    });
  }

  Future<bool> completeTask(
      BuildContext context, String taskUuid, String userUid) async {
    final user = await _homeRepository.completeTask(taskUuid, userUid);
    return user.fold((l) {
      showSnackbar(context, l.errorMessage);
      return false;
    }, (user) {
      _ref.read(currentUserProvider.notifier).state = user;
      return true;
    });
  }

  Future<bool> removeCompleted(
      BuildContext context, String taskUuid, String userUid) async {
    final user = await _homeRepository.removeCompleted(taskUuid, userUid);
    return user.fold((l) {
      showSnackbar(context, l.errorMessage);
      return false;
    }, (user) {
      _ref.read(currentUserProvider.notifier).state = user;
      return true;
    });
  }

  Future<bool> updateTask(BuildContext context, String taskUuid, String userUid,
      TaskModel updatedTask) async {
    final user =
        await _homeRepository.updateTask(taskUuid, userUid, updatedTask);
    return user.fold((l) {
      showSnackbar(context, l.errorMessage);
      return false;
    }, (user) {
      _ref.read(currentUserProvider.notifier).state = user;
      return true;
    });
  }

  Future<bool> deleteTask(
      BuildContext context, String taskUuid, String userUid) async {
    final user = await _homeRepository.deleteTask(
      taskUuid,
      userUid,
    );
    return user.fold((l) {
      showSnackbar(context, l.errorMessage);
      return false;
    }, (user) {
      _ref.read(currentUserProvider.notifier).state = user;
      return true;
    });
  }
}
