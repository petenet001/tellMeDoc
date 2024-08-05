import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

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
      throw ServerException();
    }
  }

  @override
  Future<User> signUpWithEmailAndPassword(String email, String password) async {
    try {
      return await remoteDataSource.signUpWithEmailAndPassword(email, password);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      return await remoteDataSource.signInWithGoogle();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      return await remoteDataSource.getCurrentUser();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<User> updateUserProfile(User user) async {
    try {
      final updatedUser = await remoteDataSource.updateUserProfile(user);
      return updatedUser;
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }
}