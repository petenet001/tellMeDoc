import 'package:tell_me_doctor/features/auth/domain/entities/user.dart';
import 'package:tell_me_doctor/features/auth/domain/repositories/auth_repository.dart';

class SignUpWithEmailAndPasswordUseCase{
  final AuthRepository repository;

  SignUpWithEmailAndPasswordUseCase(this.repository);

  Future<User> call(String email, String password) async {
    return await repository.signUpWithEmailAndPassword(email, password);
  }
}
