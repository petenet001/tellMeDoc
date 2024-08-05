import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tell_me_doctor/features/auth/domain/entities/user.dart';
import 'package:tell_me_doctor/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:tell_me_doctor/features/auth/domain/usecases/sign_in_with_email_and_password_usecase.dart';
import 'package:tell_me_doctor/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:tell_me_doctor/features/auth/domain/usecases/sign_up_with_email_and_password_usecase.dart';
import 'package:tell_me_doctor/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:tell_me_doctor/features/auth/presentation/riverpod/auth_providers.dart';
import 'package:tell_me_doctor/features/auth/presentation/riverpod/auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  late final GetCurrentUserUseCase _getCurrentUser;
  late final SignInWithEmailAndPasswordUseCase _signInWithEmailAndPassword;
  late final SignUpWithEmailAndPasswordUseCase _signUpWithEmailAndPassword;
  late final SignOutUseCase _signOut;
  late final UpdateProfileUseCase _updateUserProfile;
  late final firebase_auth.FirebaseAuth _firebaseAuth;
  late final SharedPreferences _prefs;

  @override
  AuthState build() {
    _getCurrentUser = ref.read(getCurrentUserUseCaseProvider);
    _signInWithEmailAndPassword = ref.read(signInWithEmailAndPasswordUseCaseProvider);
    _signUpWithEmailAndPassword = ref.read(signUpWithEmailAndPasswordUseCaseProvider);
    _signOut = ref.read(signOutUseCaseProvider);
    _updateUserProfile = ref.read(updateProfileUseCaseProvider);
    _firebaseAuth = firebase_auth.FirebaseAuth.instance;

    initializeAuth();
    return AuthState();
  }

  Future<void> initializeAuth() async {
    _prefs = await SharedPreferences.getInstance();
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
    await _checkCurrentUser();
  }

  Future<void> _onAuthStateChanged(firebase_auth.User? firebaseUser) async {
    if (firebaseUser == null) {
      await _prefs.remove('user');
      state = AuthState();
    } else {
      final user = await _getCurrentUser();
      if (user != null) {
        await _prefs.setString('user', _userToJson(user));
        state = state.copyWith(user: user);
      }
    }
  }

  Future<void> _checkCurrentUser() async {
    state = state.copyWith(isLoading: true);
    try {
      final userJson = _prefs.getString('user');
      if (userJson != null) {
        final user = _userFromJson(userJson);
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
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await _signOut();
      await _prefs.remove('user');
      state = AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> updateProfile(User user) async {
    state = state.copyWith(isLoading: true);
    try {
      final updatedUser = await _updateUserProfile(user);
      await _prefs.setString('user', _userToJson(updatedUser));
      state = state.copyWith(isLoading: false, user: updatedUser);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  String _userToJson(User user) {
    return json.encode({
      'id': user.id,
      'email': user.email,
      'name': user.name,
    });
  }

  User _userFromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }
}