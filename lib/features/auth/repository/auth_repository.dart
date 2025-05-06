import 'package:aurelius/core/constants/firebase_constants.dart';
import 'package:aurelius/core/failure.dart';
import 'package:aurelius/core/providers/firebase_providers.dart';
import 'package:aurelius/core/typedef.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:aurelius/models/user.dart';
import 'package:hive/hive.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    ref.read(authProvider),
    ref.read(firestoreProvider),
    ref.read(googleSignInProvider)));

class AuthRepository {
  AuthRepository(
      FirebaseAuth auth, FirebaseFirestore firestore, GoogleSignIn googleSignIn)
      : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  EitherUser<UserModel> googleSignIn() async {
    try {
      final userBox = Hive.box('user');
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
            email: userCredential.user?.email ?? '');

        await _firestore
            .collection('Users')
            .doc(userCredential.user!.uid)
            .set(user.toMap());
      } else {
        user = await getUserData(userCredential.user!.uid);
      }
      userBox.put('user', user);

      return right(userBox.get('user'));
    } on FirebaseAuthException catch (error) {
      throw error.message!;
    } catch (error) {
      return left(Failure(error.toString()));
    }
  }

  Future<UserModel> getUserData(String id) async {
    UserModel user = await _firestore
        .collection(FirebaseConstants.userCollection)
        .doc(id)
        .snapshots()
        .map((data) => UserModel.fromMap(data.data() as Map<String, dynamic>))
        .first;
    return user;
  }

  UserModel loadCachedUser() {
    return Hive.box('user').get('user');
  }
}
