import 'package:tell_me_doctor/features/docai/domain/entities/medical_provider.dart';

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
  });

  factory MedicalProviderModel.fromJson(Map<String, dynamic> json) {
    return MedicalProviderModel(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
      phone: json['phone'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      placeName: json['placeName'],
      placeType: json['placeType'],
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
    );
  }
}