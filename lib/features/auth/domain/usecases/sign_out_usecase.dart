import 'package:tell_me_doctor/features/auth/domain/repositories/auth_repository.dart';

class SignOutUseCase{
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<void> call() async {
    return await repository.signOut();
  }
}