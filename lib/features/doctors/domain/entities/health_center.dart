import 'package:equatable/equatable.dart';

class HealthCenter extends Equatable {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> specialties;
  final String? profileImageUrl;

  const HealthCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.specialties,
    this.profileImageUrl, // Initialisation du champ
  });

  @override
  List<Object?> get props => [id, name, address, latitude, longitude, specialties, profileImageUrl];
}
