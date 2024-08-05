import 'package:equatable/equatable.dart';

class MedicalProvider extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;
  final String? placeName;
  final String? placeType;

  const MedicalProvider({
    required this.id,
    required this.name,
    required this.specialty,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.placeName,
    this.placeType,
  });

  @override
  List<Object?> get props => [id, name, specialty, phone, address, latitude, longitude, placeName, placeType];
}