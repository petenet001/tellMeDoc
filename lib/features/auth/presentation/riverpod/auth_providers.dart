import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tell_me_doctor/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:tell_me_doctor/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tell_me_doctor/features/auth/domain/repositories/auth_repository.dart';
import 'package:tell_me_doctor/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:tell_me_doctor/features/auth/domain/usecases/sign_in_with_email_and_password_usecase.dart';
import 'package:tell_me_doctor/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:tell_me_doctor/features/auth/domain/usecases/sign_up_with_email_and_password_usecase.dart';
import 'package:tell_me_doctor/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:tell_me_doctor/features/auth/presentation/riverpod/auth_notifier.dart';
import 'package:tell_me_doctor/features/auth/presentation/riverpod/auth_state.dart';

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.read(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: apiService);
});

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

final getCurrentUserUseCaseProvider = Provider((ref) => GetCurrentUserUseCase(ref.watch(authRepositoryProvider)));
final updateProfileUseCaseProvider = Provider((ref) => UpdateProfileUseCase(ref.watch(authRepositoryProvider)));
final signInWithEmailAndPasswordUseCaseProvider = Provider((ref) => SignInWithEmailAndPasswordUseCase(ref.watch(authRepositoryProvider)));
final signUpWithEmailAndPasswordUseCaseProvider = Provider((ref) => SignUpWithEmailAndPasswordUseCase(ref.watch(authRepositoryProvider)));
final signOutUseCaseProvider = Provider((ref) => SignOutUseCase(ref.watch(authRepositoryProvider)));