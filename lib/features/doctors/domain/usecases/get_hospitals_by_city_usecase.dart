import 'package:tell_me_doctor/features/doctors/domain/entities/health_center.dart';
import 'package:tell_me_doctor/features/doctors/domain/repositories/doctor_repository.dart';

class GetHospitalsByCityUseCase {
  final DoctorRepository repository;

  GetHospitalsByCityUseCase(this.repository);

  Future<List<HealthCenter>> call(String city) {
    return repository.getHospitalsByCity(city);
  }
}
