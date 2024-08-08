import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';
import 'package:tell_me_doctor/features/doctors/domain/repositories/doctor_repository.dart';

class GetHospitalsBySpecialtyUseCase {
  final DoctorRepository repository;

  GetHospitalsBySpecialtyUseCase(this.repository);

  Future<List<MedicalProvider>> call(String specialty) async {
    return await repository.getHospitalsBySpecialty(specialty);
  }
}