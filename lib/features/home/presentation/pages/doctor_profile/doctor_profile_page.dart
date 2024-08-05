// lib/features/docai/presentation/pages/doctor_profile_page.dart
import 'package:flutter/material.dart';
import 'package:tell_me_doctor/features/docai/domain/entities/medical_provider.dart';

class DoctorProfilePage extends StatelessWidget {
  final MedicalProvider doctor;

  const DoctorProfilePage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctor.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              doctor.specialty,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(doctor.address),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(doctor.phone),
              onTap: () {
                // Implémenter la logique pour appeler le numéro
              },
            ),
            if (doctor.placeName != null)
              ListTile(
                leading: const Icon(Icons.business),
                title: Text(doctor.placeName!),
              ),
            if (doctor.placeType != null)
              ListTile(
                leading: const Icon(Icons.local_hospital),
                title: Text(doctor.placeType!),
              ),
            // Vous pouvez ajouter plus d'informations ici, comme les horaires,
            // les spécialités détaillées, les assurances acceptées, etc.
          ],
        ),
      ),
    );
  }
}