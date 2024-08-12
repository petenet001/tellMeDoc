import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tell_me_doctor/features/auth/data/models/user_model.dart';
import 'package:tell_me_doctor/features/auth/domain/entities/user.dart';
import 'package:tell_me_doctor/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:tell_me_doctor/features/auth/domain/usecases/sign_in_with_email_and_password_usecase.dart';
import 'package:tell_me_doctor/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:tell_me_doctor/features/auth/domain/usecases/sign_up_with_email_and_password_usecase.dart';
import 'package:tell_me_doctor/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:tell_me_doctor/features/auth/presentation/riverpod/auth_providers.dart';
import 'package:tell_me_doctor/features/auth/presentation/riverpod/auth_state.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/exceptions.dart';

class AuthNotifier extends Notifier<AuthState> {
  late final GetCurrentUserUseCase _getCurrentUser;
  late final SignInWithEmailAndPasswordUseCase _signInWithEmailAndPassword;
  late final SignUpWithEmailAndPasswordUseCase _signUpWithEmailAndPassword;
  late final SignOutUseCase _signOut;
  late final UpdateProfileUseCase _updateUserProfile;
  late final SharedPreferences _prefs;
  late final GoogleSignIn _googleSignIn;

  @override
  AuthState build() {
    _getCurrentUser = ref.read(getCurrentUserUseCaseProvider);
    _signInWithEmailAndPassword = ref.read(signInWithEmailAndPasswordUseCaseProvider);
    _signUpWithEmailAndPassword = ref.read(signUpWithEmailAndPasswordUseCaseProvider);
    _signOut = ref.read(signOutUseCaseProvider);
    _updateUserProfile = ref.read(updateProfileUseCaseProvider);
    _googleSignIn = GoogleSignIn();

    _initializeAuth();
    return AuthState();
  }

  Future<void> _initializeAuth() async {
    _prefs = await SharedPreferences.getInstance();
    firebase_auth.FirebaseAuth.instance.authStateChanges().listen(_onAuthStateChanged);
    await _checkCurrentUser();
  }

  Future<void> _onAuthStateChanged(firebase_auth.User? firebaseUser) async {
    if (firebaseUser == null) {
      await _prefs.remove('user');
      state = AuthState();
    } else {
      try {
        final user = await _getCurrentUser();
        if (user != null) {
          await _prefs.setString('user', json.encode(UserModel.fromEntity(user).toJson()));
          state = state.copyWith(user: user);
        }
      } on ServerException catch (e) {
        log("ServerException encountered during auth state change: ${e.toString()}");
        state = state.copyWith(errorMessage: "Server error occurred. Please try again later.");
      } catch (e) {
        log("Unexpected error during auth state change: ${e.toString()}");
        state = state.copyWith(errorMessage: "An unexpected error occurred. Please try again.");
      }
    }
  }

  Future<void> _checkCurrentUser() async {
    state = state.copyWith(isLoading: true);
    try {
      final userJson = _prefs.getString('user');
      if (userJson != null) {
        final user = UserModel.fromJson(json.decode(userJson)).toEntity();
        state = state.copyWith(isLoading: false, user: user);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _signInWithEmailAndPassword(email, password);
      state = state.copyWith(isLoading: false, user: user);
      await _prefs.setString('user', json.encode(UserModel.fromEntity(user).toJson()));
    } on firebase_auth.FirebaseAuthException catch (e) {
      log("Firebase auth error: ${e.message}");
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } on AuthException catch (e) {
      log("Custom auth error: ${e.message}");
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } on ServerException catch (e) {
      log("ServerException encountered: ${e.toString()}");
      state = state.copyWith(isLoading: false, errorMessage: "Server error occurred. Please try again later.");
    } catch (e, stackTrace) {
      log("Unexpected error: ${e.toString()}", error: e, stackTrace: stackTrace);
      state = state.copyWith(isLoading: false, errorMessage: "An unexpected error occurred. Please try again.");
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _signUpWithEmailAndPassword(email, password);
      state = state.copyWith(isLoading: false, user: user);
      await _prefs.setString('user', json.encode(UserModel.fromEntity(user).toJson()));
    } on firebase_auth.FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      log("Firebase auth error: ${e.message}");
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      log("Custom auth error: ${e.message}");
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      log("Unexpected error: ${e.toString()}");
    }
  }

  Future<void> signOut(BuildContext context) async {
    state = state.copyWith(isLoading: true);
    try {
      await _signOut();
      await _prefs.remove('user');
      state = AuthState();
      if (context.mounted) {
        context.go('/login');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      log("Unexpected error during sign out: ${e.toString()}");
    }
  }

  Future<void> updateUserProfile(User updatedUser) async {
    state = state.copyWith(isLoading: true);
    try {
      await _updateUserProfile(updatedUser);
      await _prefs.setString('user', json.encode(UserModel.fromEntity(updatedUser).toJson()));
      state = state.copyWith(isLoading: false, user: updatedUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        log("User needs to re-authenticate to update profile");
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Please log in again to update your profile.',
        );
      } else {
        state = state.copyWith(isLoading: false, errorMessage: e.message);
        log("Firebase auth error: ${e.message}");
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      log("Unexpected error during profile update: ${e.toString()}");
    }
  }

  Future<void> updateProfilePicture(String photoUrl) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = state.user;
      if (user != null) {
        final updatedUser = user.copyWith(photoUrl: photoUrl);
        await _updateUserProfile(updatedUser);
        await _prefs.setString('user', json.encode(UserModel.fromEntity(updatedUser).toJson()));
        state = state.copyWith(isLoading: false, user: updatedUser);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      log("Unexpected error during profile picture update: ${e.toString()}");
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true);
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebase_auth.FirebaseAuth.instance.signInWithCredential(credential);
      final user = UserModel.fromFirebaseUser(userCredential.user!);

      state = state.copyWith(isLoading: false, user: user.toEntity());
      await _prefs.setString('user', json.encode(user.toJson()));
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      log("Unexpected error during Google sign in: ${e.toString()}");
    }
  }
}
