import 'package:tell_me_doctor/features/doctors/data/datasources/remote/doctor_remote_data_source.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/doctor_category.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';
import 'package:tell_me_doctor/features/doctors/domain/repositories/doctor_repository.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource remoteDataSource;

  DoctorRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MedicalProvider>> getTopDoctors() async {
    return await remoteDataSource.getTopDoctors();
  }

  @override
  Future<List<DoctorCategory>> getDoctorCategories() async {
    return await remoteDataSource.getDoctorCategories();
  }

  @override
  Future<List<MedicalProvider>> getDoctorsBySpecialty(String specialty) async {
    return await remoteDataSource.getDoctorsBySpecialty(specialty);
  }

  @override
  Future<List<MedicalProvider>> getHospitalsBySpecialty(String specialty) async {
    return await remoteDataSource.getHospitalsBySpecialty(specialty);
  }
}