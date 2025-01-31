import 'package:flutter/material.dart';
import 'package:tell_me_doctor/features/home/presentation/widgets/doctor_profile.dart';
import 'package:tell_me_doctor/features/home/presentation/widgets/health_needs.dart';
import 'package:tell_me_doctor/features/home/presentation/widgets/nearby_doctor.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(14),
      children: const [
        Text(
          "Hi, Pierre",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24
          ),
        ),
        Text(
          "How are you feeling today?",
          style: TextStyle(
            fontSize: 17,
            color: Colors.black45,
            fontWeight: FontWeight.w500,
          ),
        ),
        DoctorProfile(),
        SizedBox(height: 20),
        Text(
          "Health Needs",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        HealthNeeds(),
        SizedBox(height: 20),
        Text(
          "Nearby Doctor",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        NearbyDoctor(),
      ],
    );
  }
}
