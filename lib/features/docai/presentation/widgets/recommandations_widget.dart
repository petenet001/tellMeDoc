import 'package:flutter/material.dart';
import 'package:tell_me_doctor/features/docai/presentation/widgets/doctor_card.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';

class RecommandationsWidget extends StatelessWidget {
  final List<MedicalProvider> doctors;
  const RecommandationsWidget({super.key,required this.doctors});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Professionnels de santé recommandés :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.purple.shade800,
            ),
          ),
          const SizedBox(height: 8),
          ...doctors.map((doctor) => DoctorCard(doctor: doctor)),
        ],
      ),
    );
  }
}
