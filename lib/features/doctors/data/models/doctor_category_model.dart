import 'package:flutter/material.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/doctor_category.dart';

class DoctorCategoryModel extends DoctorCategory {
  const DoctorCategoryModel({
    required super.id,
    required super.specialty,
    required super.count,
    required super.color,
    super.icon,
    super.description,
  });

  factory DoctorCategoryModel.fromJson(Map<String, dynamic> json) {
    return DoctorCategoryModel(
      id: json['id'] ?? '',
      specialty: json['specialty'] ?? '',
      count: json['count'] ?? 0,
      color: Color(json['color'] ?? 0xFFFFFFFF),  // Assuming color is stored as an int
      icon: json['icon'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'specialty': specialty,
      'count': count,
      'color': color.value,  // Storing color as an int
      'icon': icon,
      'description': description,
    };
  }

  factory DoctorCategoryModel.fromEntity(DoctorCategory entity) {
    return DoctorCategoryModel(
      id: entity.id,
      specialty: entity.specialty,
      count: entity.count,
      color: entity.color,
      icon: entity.icon,
      description: entity.description,
    );
  }

  DoctorCategory toEntity() {
    return DoctorCategory(
      id: id,
      specialty: specialty,
      count: count,
      color: color,
      icon: icon,
      description: description,
    );
  }
}