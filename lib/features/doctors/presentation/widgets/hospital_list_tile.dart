import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';

class HospitalListTile extends StatelessWidget {
  final MedicalProvider hospital;

  const HospitalListTile({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.black.withOpacity(.05),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          // Navigate to hospital details page if necessary
          // Example: context.push('/hospital_profile/${hospital.id}', extra: hospital);
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  image: const DecorationImage(
                    image: AssetImage('assets/doctor_background.png'), // Assurez-vous d'avoir cette image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital.placeName ?? 'Unknown',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      hospital.placeType ?? 'Hospital',
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    Text(
                      hospital.address,
                      style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                    ),
                  ],
                ),
              ),
             // const Icon(Icons.chevron_right, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}