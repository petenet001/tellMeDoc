import 'package:flutter/material.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';
import 'package:go_router/go_router.dart';

class DoctorCard extends StatelessWidget {
  final MedicalProvider doctor;
  const DoctorCard({super.key,required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      color: Colors.black.withOpacity(.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.purple.shade200,
          child: Text(
            doctor.name[0],
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          doctor.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(doctor.specialty),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.purple.shade300),
        onTap: () {
          context.push('/doc_profile/${doctor.id}', extra: doctor);
        },
      ),
    );
  }
}
