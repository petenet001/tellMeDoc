import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tell_me_doctor/features/doctors/data/models/doctor_category_model.dart';
import 'package:tell_me_doctor/features/doctors/data/models/medical_provider_model.dart';
import 'package:tell_me_doctor/features/doctors/data/models/health_center_model.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/health_center.dart';

class DoctorRemoteDataSource {
  final FirebaseFirestore firestore;
  final Random random = Random();

  DoctorRemoteDataSource(this.firestore);

  Color _getRandomColor() {
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  Future<List<MedicalProviderModel>> getTopDoctors() async {
    final querySnapshot = await firestore.collection('doctors').limit(3).get();
    final doctors = await Future.wait(querySnapshot.docs.map((doc) async {
      final data = doc.data();
      final healthCenter = await _getHealthCenterForDoctor(data['healthCenterId']);
      return MedicalProviderModel.fromJson(doc.id, data, healthCenter);
    }));

    return doctors;
  }

  Future<List<DoctorCategoryModel>> getDoctorCategories() async {
    final querySnapshot = await firestore.collection('doctors').get();

    Map<String, int> categoryCounts = {};

    for (var doc in querySnapshot.docs) {
      String specialty = doc['specialty'];
      categoryCounts[specialty] = (categoryCounts[specialty] ?? 0) + 1;
    }

    return categoryCounts.entries
        .map((e) => DoctorCategoryModel(
      id: e.key,
      specialty: e.key,
      count: e.value,
      color: _getRandomColor(),
    ))
        .toList();
  }

  Future<List<MedicalProviderModel>> getDoctorsBySpecialty(String specialty) async {
    final snapshot = await firestore.collection('doctors')
        .where('specialty', isEqualTo: specialty)
        .get();

    final doctors = await Future.wait(snapshot.docs.map((doc) async {
      final data = doc.data();
      final healthCenter = await _getHealthCenterForDoctor(data['healthCenterId']);
      return MedicalProviderModel.fromJson(doc.id, data, healthCenter);
    }));

    return doctors;
  }

  Future<List<HealthCenterModel>> getHospitalsBySpecialty(String specialty) async {
    final snapshot = await firestore.collection('centers')
        .where('specialties', arrayContains: specialty)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return HealthCenterModel.fromJson(doc.id, data);
    }).toList();
  }

  Future<List<MedicalProviderModel>> getDoctorsByCity(String city) async {
    final snapshot = await firestore.collection('doctors').get();

    final filteredDocs = snapshot.docs.where((doc) {
      final address = doc.data()['address'] as String;
      return address.contains(city);
    }).toList();

    final doctors = await Future.wait(filteredDocs.map((doc) async {
      final data = doc.data();
      final healthCenter = await _getHealthCenterForDoctor(data['healthCenterId']);
      return MedicalProviderModel.fromJson(doc.id, data, healthCenter);
    }));

    return doctors;
  }

  Future<List<HealthCenterModel>> getHospitalsByCity(String city) async {
    final snapshot = await firestore.collection('centers').get();

    final filteredDocs = snapshot.docs.where((doc) {
      final address = doc.data()['address'] as String;
      return address.contains(city);
    }).toList();

    final hospitals = await Future.wait(filteredDocs.map((doc) async {
      final data = doc.data();
      return HealthCenterModel.fromJson(doc.id, data);
    }));

    return hospitals;
  }

  Future<HealthCenterModel?> _getHealthCenterForDoctor(String? healthCenterId) async {
    if (healthCenterId == null) return null;

    final healthCenterSnapshot = await firestore.collection('centers').doc(healthCenterId).get();
    if (healthCenterSnapshot.exists) {
      final data = healthCenterSnapshot.data();
      return HealthCenterModel.fromJson(healthCenterSnapshot.id, data!);
    }
    return null;
  }
}
