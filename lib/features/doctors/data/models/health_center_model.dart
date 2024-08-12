import 'package:tell_me_doctor/features/doctors/domain/entities/health_center.dart';

class HealthCenterModel extends HealthCenter {
  const HealthCenterModel({
    required super.id,
    required super.name,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.specialties,
  });

  factory HealthCenterModel.fromJson(String id, Map<String, dynamic> json) {
    return HealthCenterModel(
      id: id,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      specialties: List<String>.from(json['specialties'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'specialties': specialties,
    };
  }
}
