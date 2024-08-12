import 'package:equatable/equatable.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/health_center.dart';

class MedicalProvider extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;
  final HealthCenter? healthCenter;
  final int? rating;
  final String? profileImageUrl;

  const MedicalProvider({
    required this.id,
    required this.name,
    required this.specialty,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.healthCenter,
    required this.rating,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [id, name, specialty, phone, address, latitude, longitude, healthCenter, rating, profileImageUrl];
}
