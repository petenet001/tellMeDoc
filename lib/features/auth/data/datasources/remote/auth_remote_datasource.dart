import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tell_me_doctor/core/error/exceptions.dart';
import 'package:tell_me_doctor/features/auth/data/models/user_model.dart';
import 'package:tell_me_doctor/features/auth/domain/entities/user.dart';

class AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSource({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn,
        _firestore = firestore;

  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    try {
      log("Attempting to sign in with email: $email");
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      log("Firebase sign-in successful for user ID: ${userCredential.user?.uid}");
      return _getOrCreateUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      log("FirebaseAuthException during sign in: ${e.message}");
      throw AuthException(e.message ?? 'An error occurred during sign in');
    } catch (e) {
      log("Unexpected error during sign in: $e");
      throw ServerException("Failed to sign in", e.toString());
    }
  }

  Future<UserModel> signUpWithEmailAndPassword(String email, String password) async {
    try {
      log("Attempting to sign up with email: $email");
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      log("Firebase sign-up successful for user ID: ${userCredential.user?.uid}");
      return _createUserProfile(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      log("FirebaseAuthException during sign up: ${e.message}");
      throw AuthException(e.message ?? 'An error occurred during sign up');
    } catch (e) {
      log("Unexpected error during sign up: $e");
      throw ServerException("Failed to sign up", e.toString());
    }
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      log("Attempting to sign in with Google");
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      log("Google sign-in successful for user ID: ${userCredential.user?.uid}");
      return _getOrCreateUser(userCredential.user!);
    } catch (e) {
      log("Unexpected error during Google sign in: $e");
      throw AuthException('Failed to sign in with Google');
    }
  }

  Future<void> signOut() async {
    try {
      log("Signing out");
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      log("Unexpected error during sign out: $e");
      throw AuthException('Failed to sign out');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        log("Fetching user profile from Firestore for user ID: ${user.uid}");
        final snapshot = await _firestore.collection('users').doc(user.uid).get();
        if (snapshot.exists) {
          log("User profile found in Firestore: ${snapshot.data()}");
          return UserModel.fromJson(snapshot.data()!);
        } else {
          log("No user profile found in Firestore for user ID: ${user.uid}");
        }
      } else {
        log("No current user signed in with Firebase.");
      }
      return null;
    } catch (e) {
      log("Error while fetching current user: $e");
      throw ServerException("Failed to get current user", e.toString());
    }
  }

  Future<UserModel> updateUserProfile(User user) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;

      if (firebaseUser != null) {
        log("Updating user profile for user ID: ${firebaseUser.uid}");
        await firebaseUser.verifyBeforeUpdateEmail(user.email);
        await firebaseUser.updateDisplayName("${user.firstName} ${user.name}");

        final userRef = _firestore.collection('users').doc(firebaseUser.uid);
        await userRef.update({
          'firstName': user.firstName,
          'lastName': user.name,
          'phoneNumber': user.phone,
          'city': user.city,
          'photoUrl': user.photoUrl,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        final updatedSnapshot = await userRef.get();
        log("User profile updated in Firestore: ${updatedSnapshot.data()}");
        return UserModel.fromJson(updatedSnapshot.data()!);
      } else {
        log("No user signed in to update profile.");
        throw Exception('No user is signed in');
      }
    } catch (e) {
      log("Error during user profile update: $e");
      throw Exception('Failed to update user profile: $e');
    }
  }

  Future<UserModel> _createUserProfile(firebase_auth.User firebaseUser) async {
    final userRef = _firestore.collection('users').doc(firebaseUser.uid);
    final newUser = UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email!,
      firstName: firebaseUser.displayName?.split(' ').first,
      name: firebaseUser.displayName?.split(' ').last,
      photoUrl: firebaseUser.photoURL,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    log("Creating user profile in Firestore for user ID: ${firebaseUser.uid}");
    await userRef.set(newUser.toJson());
    return newUser;
  }

  Future<UserModel> _getOrCreateUser(firebase_auth.User firebaseUser) async {
    final userRef = _firestore.collection('users').doc(firebaseUser.uid);
    final snapshot = await userRef.get();

    if (snapshot.exists) {
      log("User profile already exists in Firestore for user ID: ${firebaseUser.uid}");
      return UserModel.fromJson(snapshot.data()!);
    } else {
      log("User profile does not exist in Firestore, creating new profile for user ID: ${firebaseUser.uid}");
      return _createUserProfile(firebaseUser);
    }
  }
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(
    firebaseAuth: firebase_auth.FirebaseAuth.instance,
    googleSignIn: GoogleSignIn(),
    firestore: FirebaseFirestore.instance,
  );
});
