import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DoctorCategory extends Equatable {
  final String id;
  final String specialty;
  final int count;
  final Color color;
  final String? icon;
  final String? description;

  const DoctorCategory({
    required this.id,
    required this.specialty,
    required this.count,
    required this.color,
    this.icon,
    this.description,
  });

  @override
  List<Object?> get props => [
    id,
    specialty,
    count,
    color,
    icon,
    description,
  ];
}