import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';

class DoctorListTile extends StatelessWidget {
  final MedicalProvider doctor;

  const DoctorListTile({
    super.key,
    required this.doctor,
  });

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
          context.push('/doc_profile/${doctor.id}', extra: doctor);
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
                  image: doctor.profileImageUrl != null
                      ? DecorationImage(
                    image: NetworkImage(doctor.profileImageUrl!),
                    fit: BoxFit.cover,
                  )
                      : const DecorationImage(
                    image: AssetImage('assets/doctor_background.png'),
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
                      doctor.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      doctor.specialty,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    // Utilisation de l'objet HealthCenter
                    if (doctor.healthCenter != null) ...[
                      Text(
                        doctor.healthCenter!.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        _getPlaceTypeText(doctor.healthCenter!.specialties),
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPlaceTypeText(List<String> specialties) {
    if (specialties.isEmpty) {
      return 'No specialties available';
    }
    return specialties.join(', ');
  }
}
