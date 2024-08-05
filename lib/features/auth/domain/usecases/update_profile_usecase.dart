import 'package:tell_me_doctor/core/usecase/usecase.dart';
import 'package:tell_me_doctor/features/auth/domain/entities/user.dart';
import 'package:tell_me_doctor/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase implements UseCase<User, User> {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<User> call(User user) async {
    return await repository.updateUserProfile(user);
  }
}