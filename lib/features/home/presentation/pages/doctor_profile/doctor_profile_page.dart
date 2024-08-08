// lib/features/docai/presentation/pages/doctor_profile_page.dart
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';

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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(top: 24.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.red,
                        image: const DecorationImage(
                            image: AssetImage('assets/doctor_background.png'),
                            fit: BoxFit.cover)),
                  ),
                ),
                Column(
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
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const HeroIcon(HeroIcons.mapPin),
              title: Text(doctor.address),
            ),
            ListTile(
              leading: const HeroIcon(HeroIcons.phone),
              title: Text(doctor.phone),
              onTap: () {
                // Implémenter la logique pour appeler le numéro
              },
            ),
            if (doctor.placeName != null)
              ListTile(
                leading: const HeroIcon(HeroIcons.buildingOffice),
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