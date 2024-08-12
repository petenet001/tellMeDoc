import 'package:tell_me_doctor/features/doctors/data/datasources/remote/doctor_remote_data_source.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/doctor_category.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/health_center.dart';
import 'package:tell_me_doctor/features/doctors/domain/repositories/doctor_repository.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource remoteDataSource;

  DoctorRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MedicalProvider>> getTopDoctors() async {
    final topDoctors = await remoteDataSource.getTopDoctors();
    return topDoctors.map((doctor) => doctor as MedicalProvider).toList();
  }

  @override
  Future<List<DoctorCategory>> getDoctorCategories() async {
    return await remoteDataSource.getDoctorCategories();
  }

  @override
  Future<List<MedicalProvider>> getDoctorsBySpecialty(String specialty) async {
    final doctors = await remoteDataSource.getDoctorsBySpecialty(specialty);
    return doctors.map((doctor) => doctor as MedicalProvider).toList();
  }

  @override
  Future<List<MedicalProvider>> getDoctorsByCity(String city) async {
    final doctors = await remoteDataSource.getDoctorsByCity(city);
    return doctors.map((doctor) => doctor as MedicalProvider).toList();
  }

  @override
  Future<List<HealthCenter>> getHospitalsBySpecialty(String specialty) async {
    final hospitals = await remoteDataSource.getHospitalsBySpecialty(specialty);
    return hospitals.map((hospital) => hospital as HealthCenter).toList();
  }

  @override
  Future<List<HealthCenter>> getHospitalsByCity(String city) async {
    return await remoteDataSource.getHospitalsByCity(city);
  }
}
