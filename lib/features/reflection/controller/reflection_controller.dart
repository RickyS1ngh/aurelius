import 'package:aurelius/core/typedef.dart';
import 'package:aurelius/core/utils.dart';
import 'package:aurelius/features/auth/controller/auth_controller.dart';
import 'package:aurelius/features/reflection/repository/reflection_repostiory.dart';
import 'package:aurelius/models/reflection.dart';
import 'package:aurelius/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ReflectionControllerProvier =
    StateNotifierProvider<ReflectionController, UserModel>((ref) =>
        ReflectionController(ref.read(reflectionRepostioryProvider), ref));

class ReflectionController extends StateNotifier<UserModel> {
  ReflectionController(ReflectionRepostiory reflectionRepository, Ref ref)
      : _reflectionRepostiory = reflectionRepository,
        _ref = ref,
        super(UserModel(username: '', email: '', tasks: [], reflections: []));
  final ReflectionRepostiory _reflectionRepostiory;
  final Ref _ref;

  Future<bool> addReflection(
      BuildContext context, String title, String text, String uid) async {
    final user = await _reflectionRepostiory.addReflection(title, text, uid);

    return user.fold((l) {
      showSnackbar(context, l.errorMessage);
      return false;
    }, (user) {
      _ref.read(currentUserProvider.notifier).state = user;
      return true;
    });
  }

  Future<bool> updateReflection(BuildContext context, String reflectionUuid,
      String userUid, ReflectionModel updatedReflection) async {
    final user = await _reflectionRepostiory.updateReflection(
        reflectionUuid, userUid, updatedReflection);
    return user.fold((l) {
      showSnackbar(context, l.errorMessage);
      return false;
    }, (user) {
      _ref.read(currentUserProvider.notifier).state = user;
      return true;
    });
  }

  Future<bool> deleteReflection(
      BuildContext context, String reflectionUuid, String userUid) async {
    final user = await _reflectionRepostiory.deleteReflection(
      reflectionUuid,
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
