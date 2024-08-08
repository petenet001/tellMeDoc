import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tell_me_doctor/features/doctors/data/models/doctor_category_model.dart';
import 'package:tell_me_doctor/features/doctors/data/models/medical_provider_model.dart';

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
    print('Top doctors: ${querySnapshot.docs.map((doc) => doc.data()).toList()}');
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Add the document ID to the data
      return MedicalProviderModel.fromJson(doc.id, data);
    }).toList();
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
      id: e.key, // Using specialty as id for simplicity
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
    print('Doctors by specialty ($specialty): ${snapshot.docs.map((doc) => doc.data()).toList()}');
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Add the document ID to the data
      return MedicalProviderModel.fromJson(data['id'], data);
    }).toList();
  }

  Future<List<MedicalProviderModel>> getHospitalsBySpecialty(String specialty) async {
    final snapshot = await firestore.collection('doctors')
        .where('specialty', isEqualTo: specialty)
        .get();

    print('Structures by specialty ($specialty): ${snapshot.docs.map((doc) => doc.data()).toList()}'); // Log the results
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Add the document ID to the data
      return MedicalProviderModel.fromJson(data['id'], data);
    }).toList();
  }


/*Future<List<MedicalProviderModel>> getHospitalsBySpecialty(String specialty) async {
    final snapshot = await firestore.collection('doctors')
        .where('specialty', isEqualTo: specialty)
        .where('placeType', isEqualTo: 'Hospital')
        .get();
    print('Hospitals by specialty ($specialty): ${snapshot.docs.map((doc) => doc.data()).toList()}');
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Add the document ID to the data
      return MedicalProviderModel.fromJson(data['id'], data);
    }).toList();
  }*/
}