import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? firstName;
  final String? name; // équivalent de lastName
  final String? phone;
  final String? city;
  final String? photoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    this.firstName,
    this.name,
    this.phone,
    this.city,
    this.photoUrl,
    this.createdAt,
    this.updatedAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? name,
    String? phone,
    String? city,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    name,
    phone,
    city,
    photoUrl,
    createdAt,
    updatedAt,
  ];
}
