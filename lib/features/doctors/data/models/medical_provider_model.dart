import 'package:tell_me_doctor/features/doctors/domain/entities/health_center.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';

class MedicalProviderModel extends MedicalProvider {
  const MedicalProviderModel({
    required super.id,
    required super.name,
    required super.specialty,
    required super.phone,
    required super.address,
    required super.latitude,
    required super.longitude,
    super.healthCenter,
    super.rating,
    super.profileImageUrl, // Ajout du champ pour l'URL de l'image de profil
  });

  factory MedicalProviderModel.fromJson(String id, Map<String, dynamic> json, [HealthCenter? healthCenter]) {
    return MedicalProviderModel(
      id: id,
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      healthCenter: healthCenter, // Référence optionnelle au centre de santé
      rating: json['rating'] as int?,
      profileImageUrl: json['profileImageUrl'], // Ajout du champ pour l'URL de l'image de profil
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'phone': phone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'healthCenterId': healthCenter?.id, // On stocke uniquement l'ID du centre de santé
      'rating': rating,
      'profileImageUrl': profileImageUrl, // Ajout de l'URL de l'image dans la méthode toJson
    };
  }

  factory MedicalProviderModel.fromEntity(MedicalProvider entity) {
    return MedicalProviderModel(
      id: entity.id,
      name: entity.name,
      specialty: entity.specialty,
      phone: entity.phone,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      healthCenter: entity.healthCenter,
      rating: entity.rating,
      profileImageUrl: entity.profileImageUrl, // Ajout du champ pour l'URL de l'image de profil
    );
  }
}
