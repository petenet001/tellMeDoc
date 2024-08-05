import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tell_me_doctor/features/docai/data/model/medical_provider_model.dart';

class FirebaseMedicalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MedicalProviderModel>> searchMedicalProviders(String specialty) async {
    try {
      final querySnapshot = await _firestore
          .collection('medical_providers')
          .where('specialty', isEqualTo: specialty)
          .get();

      return querySnapshot.docs
          .map((doc) => MedicalProviderModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error searching medical providers: $e');
      return [];
    }
  }
}