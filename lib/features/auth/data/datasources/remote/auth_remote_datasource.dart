import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tell_me_doctor/features/auth/domain/entities/user.dart';
import '../../../../../core/error/exceptions.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signUpWithEmailAndPassword(String email, String password);
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<User> updateUserProfile(User user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth, _googleSignIn = googleSignIn;

  @override
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'An error occurred during sign in');
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'An error occurred during sign up');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      throw AuthException('Failed to sign in with Google');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException('Failed to sign out');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }

  @override
  Future<User> updateUserProfile(User user) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(user.name);
      await _firebaseAuth.currentUser?.verifyBeforeUpdateEmail(user.email);

      // Récupérez l'utilisateur mis à jour
      final updatedFirebaseUser = _firebaseAuth.currentUser;
      if (updatedFirebaseUser != null) {
        return User(
          id: updatedFirebaseUser.uid,
          email: updatedFirebaseUser.email!,
          name: updatedFirebaseUser.displayName,
        );
      } else {
        throw Exception('User not found after update');
      }
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
 firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
 GoogleSignIn googleSignIn = GoogleSignIn();
  return AuthRemoteDataSourceImpl(firebaseAuth: firebaseAuth,googleSignIn: googleSignIn);
});

