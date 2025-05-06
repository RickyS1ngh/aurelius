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
          UserModel(username: '', uid: '', email: ''),
        );

  final AuthRepository _authRepository;
  final Ref _ref;

  Future<void> googleSign(BuildContext context) async {
    final user = await _authRepository.googleSignIn();
    user.fold((l) => showSnackbar(context, l.errorMessage), (user) {
      _ref.read(currentUserProvider.notifier).state = user;
    });
  }

  void loadCachedUser() {
    final cachedUser = _authRepository.loadCachedUser();
    _ref.read(currentUserProvider.notifier).state = cachedUser;
  }
}
