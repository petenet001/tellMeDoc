import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tell_me_doctor/features/doctors/data/datasources/remote/doctor_remote_data_source.dart';
import 'package:tell_me_doctor/features/doctors/data/repositories/doctor_repository_impl.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/doctor_category.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/health_center.dart';
import 'package:tell_me_doctor/features/doctors/domain/usecases/get_doctor_categories_usecase.dart';
import 'package:tell_me_doctor/features/doctors/domain/usecases/get_doctors_by_city_usecase.dart';
import 'package:tell_me_doctor/features/doctors/domain/usecases/get_hospital_by_category_usecase.dart';
import 'package:tell_me_doctor/features/doctors/domain/usecases/get_hospitals_by_city_usecase.dart';
import 'package:tell_me_doctor/features/doctors/domain/usecases/get_top_doctor_usecase.dart';
import 'package:tell_me_doctor/features/doctors/domain/usecases/get_doctors_by_specialty_usecase.dart';

final doctorRepositoryProvider = Provider((ref) => DoctorRepositoryImpl(DoctorRemoteDataSource(FirebaseFirestore.instance)));

final getTopDoctorsProvider = Provider((ref) => GetTopDoctorsUsecase(ref.watch(doctorRepositoryProvider)));

final topDoctorsProvider = FutureProvider<List<MedicalProvider>>((ref) async {
  final getTopDoctors = ref.watch(getTopDoctorsProvider);
  return await getTopDoctors();
});

final getDoctorCategoriesProvider = Provider((ref) {
  final repository = ref.watch(doctorRepositoryProvider);
  return GetDoctorCategoriesUsecase(repository);
});

final doctorCategoriesProvider = FutureProvider<List<DoctorCategory>>((ref) async {
  final getCategories = ref.watch(getDoctorCategoriesProvider);
  return getCategories();
});

final getDoctorsBySpecialtyProvider = Provider((ref) {
  final repository = ref.watch(doctorRepositoryProvider);
  return GetDoctorsBySpecialtyUsecase(repository);
});

final doctorsBySpecialtyProvider = FutureProvider.family<List<MedicalProvider>, String>((ref, specialty) async {
  final useCase = ref.watch(getDoctorsBySpecialtyProvider);
  return useCase(specialty);
});

final getHospitalsBySpecialtyProvider = Provider<GetHospitalsBySpecialtyUseCase>((ref) {
  final repository = ref.watch(doctorRepositoryProvider);
  return GetHospitalsBySpecialtyUseCase(repository);
});

// Correction: Returning a list of HealthCenter instead of MedicalProvider
final hospitalsBySpecialtyProvider = FutureProvider.family<List<HealthCenter>, String>((ref, specialty) async {
  final useCase = ref.watch(getHospitalsBySpecialtyProvider);
  return useCase(specialty);
});

final getDoctorsByCityProvider = Provider((ref) {
  final repository = ref.watch(doctorRepositoryProvider);
  return GetDoctorsByCityUsecase(repository);
});

final doctorsByCityProvider = FutureProvider.family<List<MedicalProvider>, String>((ref, city) async {
  final useCase = ref.watch(getDoctorsByCityProvider);
  return useCase(city);
});

final getHospitalsByCityProvider = Provider<GetHospitalsByCityUseCase>((ref) {
  final repository = ref.watch(doctorRepositoryProvider);
  return GetHospitalsByCityUseCase(repository);
});

final hospitalsByCityProvider = FutureProvider.family<List<HealthCenter>, String>((ref, city) async {
  final useCase = ref.watch(getHospitalsByCityProvider);
  return useCase(city);
});
