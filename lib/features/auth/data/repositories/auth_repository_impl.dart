import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:tell_me_doctor/core/error/exceptions.dart';
import 'package:tell_me_doctor/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:tell_me_doctor/features/auth/domain/entities/user.dart';
import 'package:tell_me_doctor/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await remoteDataSource.signInWithEmailAndPassword(email, password);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException("Failed to sign in with email and password", e.toString());
    }
  }

  @override
  Future<User> signUpWithEmailAndPassword(String email, String password) async {
    try {
      return await remoteDataSource.signUpWithEmailAndPassword(email, password);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException("Failed to sign up with email and password", e.toString());
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      return await remoteDataSource.signInWithGoogle();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException("Failed to sign in with Google", e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException("Failed to sign out", e.toString());
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      return await remoteDataSource.getCurrentUser();
    } catch (e) {
      throw ServerException("Failed to get current user", e.toString());
    }
  }

  @override
  Future<User> updateUserProfile(User user) async {
    try {
      final updatedUser = await remoteDataSource.updateUserProfile(user);
      return updatedUser;
    } catch (e) {
      throw ServerException('Failed to update user profile', e.toString());
    }
  }

  @override
  Future<String> uploadProfileImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pics/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw ServerException('Failed to upload image', e.toString());
    }
  }
}
