import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';
import 'package:tell_me_doctor/features/doctors/domain/repositories/doctor_repository.dart';

class GetTopDoctorsUsecase{
  final DoctorRepository repository;

  GetTopDoctorsUsecase(this.repository);

  Future<List<MedicalProvider>> call() => repository.getTopDoctors();
}