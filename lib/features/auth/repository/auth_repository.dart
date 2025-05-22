import 'package:aurelius/core/constants/constants.dart';
import 'package:aurelius/core/failure.dart';
import 'package:aurelius/core/providers/firebase_providers.dart';
import 'package:aurelius/core/typedef.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:aurelius/models/user.dart';
import 'package:hive_ce/hive.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    ref.read(authProvider),
    ref.read(firestoreProvider),
    ref.read(googleSignInProvider)));

class AuthRepository {
  AuthRepository(
    FirebaseAuth auth,
    FirebaseFirestore firestore,
    GoogleSignIn googleSignIn,
  )   : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  EitherUser<UserModel> googleSignIn() async {
    try {
      final userBox = Hive.box(Constants.userBox);
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? userAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
          idToken: userAuth!.idToken, accessToken: userAuth.accessToken);
      final userCredential = await _auth.signInWithCredential(credential);

      UserModel user;

      if (userCredential.additionalUserInfo!.isNewUser) {
        user = UserModel(
            username: userCredential.user?.displayName ?? '',
            uid: userCredential.user!.uid,
            email: userCredential.user?.email ?? '',
            tasks: []);

        await _firestore
            .collection(Constants.userCollection)
            .doc(userCredential.user!.uid)
            .set(user.toMap());
      } else {
        user = await getUserData(userCredential.user!.uid);
      }
      await userBox.put(Constants.boxKey, user);

      return right(userBox.get(Constants.boxKey));
    } on FirebaseAuthException catch (error) {
      throw error.message!;
    } catch (error) {
      return left(Failure(error.toString()));
    }
  }

  EitherUser<UserModel> appleSignIn() async {
    try {
      final userBox = Hive.box(Constants.userBox);
      final appleProvider = AppleAuthProvider();

      final userCredential = await _auth.signInWithProvider(appleProvider);

      UserModel user;

      if (userCredential.additionalUserInfo!.isNewUser) {
        user = UserModel(
            username: userCredential.user?.displayName ?? '',
            uid: userCredential.user!.uid,
            email: userCredential.user?.email ?? '',
            tasks: []);

        await _firestore
            .collection(Constants.userCollection)
            .doc(userCredential.user!.uid)
            .set(user.toMap());
      } else {
        user = await getUserData(userCredential.user!.uid);
      }
      await userBox.put(Constants.boxKey, user);

      return right(userBox.get(Constants.boxKey));
    } on SignInWithAppleException catch (e) {
      print(e);
      return left(Failure(e.toString()));
    }
  }

  Future<UserModel> getUserData(String id) async {
    UserModel user = await _firestore
        .collection(Constants.userCollection)
        .doc(id)
        .snapshots()
        .map((data) => UserModel.fromMap(data.data() as Map<String, dynamic>))
        .first;
    return user;
  }

  bool isCachedUser() {
    final userBox = Hive.box(Constants.userBox);

    if (userBox.containsKey(Constants.boxKey)) {
      return true;
    } else {
      return false;
    }
  }

  UserModel loadCachedUser() {
    return Hive.box(Constants.userBox).get(Constants.boxKey);
  }

  // UserModel getUser(String email) async {
  //   await _firestore
  //       .collection(FirebaseConstants.userCollection)
  //       .where('email', isEqualTo: email);
  // }
}
