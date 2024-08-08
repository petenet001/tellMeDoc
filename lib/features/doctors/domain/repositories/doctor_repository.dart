import 'package:tell_me_doctor/features/doctors/domain/entities/doctor_category.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';

abstract class DoctorRepository {
  Future<List<MedicalProvider>> getTopDoctors();
  Future<List<DoctorCategory>> getDoctorCategories();
  Future<List<MedicalProvider>> getDoctorsBySpecialty(String specialty);
  Future<List<MedicalProvider>> getHospitalsBySpecialty(String specialty);
}