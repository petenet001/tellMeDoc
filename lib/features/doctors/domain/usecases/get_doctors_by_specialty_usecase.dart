import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';
import 'package:tell_me_doctor/features/doctors/domain/repositories/doctor_repository.dart';

class GetDoctorsBySpecialtyUsecase {
  final DoctorRepository repository;

  GetDoctorsBySpecialtyUsecase(this.repository);

  Future<List<MedicalProvider>> call(String specialty) async {
    return await repository.getDoctorsBySpecialty(specialty);
  }
}
