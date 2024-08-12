import 'package:tell_me_doctor/features/doctors/domain/entities/doctor_category.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/health_center.dart';

/// Interface du repository pour accéder aux données des docteurs et des centres de santé.
abstract class DoctorRepository {

  /// Récupère la liste des meilleurs docteurs.
  /// Retourne une liste de MedicalProvider, qui représente les docteurs considérés comme les meilleurs.
  Future<List<MedicalProvider>> getTopDoctors();

  /// Récupère les catégories de docteurs avec le nombre de docteurs dans chaque catégorie.
  /// Retourne une liste de DoctorCategory, contenant le nom de la spécialité et le nombre de docteurs dans cette catégorie.
  Future<List<DoctorCategory>> getDoctorCategories();

  /// Récupère la liste des docteurs par spécialité.
  /// Prend en paramètre une spécialité et retourne une liste de MedicalProvider correspondant à cette spécialité.
  Future<List<MedicalProvider>> getDoctorsBySpecialty(String specialty);

  /// Récupère la liste des docteurs en fonction de la ville.
  /// Prend en paramètre une ville et retourne une liste de MedicalProvider localisés dans cette ville.
  Future<List<MedicalProvider>> getDoctorsByCity(String city);

  /// Récupère la liste des centres de santé par spécialité.
  /// Prend en paramètre une spécialité et retourne une liste de HealthCenter spécialisés dans cette spécialité.
  Future<List<HealthCenter>> getHospitalsBySpecialty(String specialty);

  /// Récupère la liste des centres de santé en fonction de la ville.
  Future<List<HealthCenter>> getHospitalsByCity(String city);

}
