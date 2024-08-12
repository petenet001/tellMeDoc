import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';

class DoctorGridTile extends StatelessWidget {
  final MedicalProvider doctor;
  const DoctorGridTile({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/doc_profile/${doctor.id}', extra: doctor);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Background Image or Profile Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: doctor.profileImageUrl != null
                  ? Image.network(
                doctor.profileImageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
                  : Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/doctor_background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            // Info section with glassmorphism effect
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: IntrinsicHeight(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Doctor's Name
                          Text(
                            doctor.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Doctor's Specialty
                          Text(
                            doctor.specialty,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Doctor's Health Center Name
                          Text(
                            doctor.healthCenter?.name ?? 'No Health Center',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
