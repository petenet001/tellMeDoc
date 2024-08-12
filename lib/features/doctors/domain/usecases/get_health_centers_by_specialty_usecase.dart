import 'package:tell_me_doctor/features/doctors/domain/entities/health_center.dart';
import 'package:tell_me_doctor/features/doctors/domain/repositories/doctor_repository.dart';

class GetHealthCentersBySpecialtyUseCase {
  final DoctorRepository repository;

  GetHealthCentersBySpecialtyUseCase(this.repository);

  Future<List<HealthCenter>> call(String specialty) async {
    return await repository.getHospitalsBySpecialty(specialty); // Vous devrez peut-être modifier le repository pour retourner des `HealthCenter` au lieu de `MedicalProvider`.
  }
}
