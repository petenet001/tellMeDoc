import 'package:tell_me_doctor/features/doctors/domain/entities/health_center.dart';
import 'package:tell_me_doctor/features/doctors/domain/repositories/doctor_repository.dart';

class GetHospitalsBySpecialtyUseCase {
  final DoctorRepository repository;

  GetHospitalsBySpecialtyUseCase(this.repository);

  Future<List<HealthCenter>> call(String specialty) async {
    return await repository.getHospitalsBySpecialty(specialty);
  }
}
