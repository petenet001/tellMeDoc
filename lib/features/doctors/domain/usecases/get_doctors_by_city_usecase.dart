import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';
import 'package:tell_me_doctor/features/doctors/domain/repositories/doctor_repository.dart';

class GetDoctorsByCityUsecase {
  final DoctorRepository repository;

  GetDoctorsByCityUsecase(this.repository);

  Future<List<MedicalProvider>> call(String city) async {
    return await repository.getDoctorsByCity(city);
  }
}
