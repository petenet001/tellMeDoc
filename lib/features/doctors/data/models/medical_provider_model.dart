import 'package:cloud_firestore/cloud_firestore.dart';
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
    super.placeName,
    super.placeType,
    super.rating
  });

  factory MedicalProviderModel.fromJson(String id, Map<String, dynamic> json) {
    return MedicalProviderModel(
      id: id,
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      placeName: json['placeName'] ?? '',
      placeType: json['placeType'] ?? '',
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
      'placeName': placeName,
      'placeType': placeType,
      'rating':rating
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
      placeName: entity.placeName,
      placeType: entity.placeType,
      rating: entity.rating
    );
  }
}