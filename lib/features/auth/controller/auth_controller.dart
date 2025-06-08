import 'package:aurelius/core/utils.dart';
import 'package:aurelius/features/auth/repository/auth_repository.dart';
import 'package:aurelius/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, UserModel>(
  (ref) => AuthController(ref.read(authRepositoryProvider), ref),
);

class AuthController extends StateNotifier<UserModel> {
  AuthController(AuthRepository authRepository, Ref ref)
      : _authRepository = authRepository,
        _ref = ref,
        super(
          UserModel(username: '', email: '', tasks: [], reflections: []),
        );

  final AuthRepository _authRepository;
  final Ref _ref;

  Future<bool> googleSign(BuildContext context) async {
    final user = await _authRepository.googleSignIn();
    return user.fold((l) {
      showSnackbar(context, l.errorMessage);
      return false;
    }, (user) {
      _ref.read(currentUserProvider.notifier).state = user;

      return true;
    });
  }

  Future<bool> appleSignin(BuildContext context) async {
    final user = await _authRepository.appleSignIn();
    return user.fold((l) {
      showSnackbar(context, l.errorMessage);
      return false;
    }, (user) {
      _ref.read(currentUserProvider.notifier).state = user;

      return true;
    });
  }

  bool isCachedUser() {
    return _authRepository.isCachedUser();
  }

  void loadCachedUser() {
    try {
      final cachedUser = _authRepository.loadCachedUser();
      _ref.read(currentUserProvider.notifier).state = cachedUser;
    } on Exception catch (e) {
      print(e);
    }
  }
}
