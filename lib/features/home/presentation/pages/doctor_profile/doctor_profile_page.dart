import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';

class DoctorProfilePage extends StatelessWidget {
  final MedicalProvider doctor;

  const DoctorProfilePage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with background image
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                doctor.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/doctor_background.png', // Replace with the actual profile image
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                  Container(
                    color: Colors.purple.withOpacity(0.2), // Color overlay with opacity
                  ),
                ],
              ),
            ),
          ),

          // SliverToBoxAdapter for the rest of the content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Doctor Info Card
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctor.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                doctor.specialty,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              if (doctor.healthCenter != null)
                                Text(
                                  doctor.healthCenter!.name,
                                  style:  TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[900],
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16,),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(onPressed: (){
                              // Implement phone call action
                            }, icon: const HeroIcon(HeroIcons.phone, size: 28)),
                            IconButton(onPressed: (){
                              // Implement chat action
                            }, icon: const HeroIcon(HeroIcons.chatBubbleLeftRight, size: 28)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Additional Info Cards
                  _buildInfoCard(
                    icon: const HeroIcon(HeroIcons.mapPin, size: 28),
                    label: doctor.address,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoCard(
                    icon: const HeroIcon(HeroIcons.phone, size: 28),
                    label: doctor.phone,
                    onTap: () {
                      // Implement phone call action
                    },
                  ),
                  const SizedBox(height: 10),
                  if (doctor.healthCenter != null)
                    _buildInfoCard(
                      icon: const HeroIcon(HeroIcons.buildingOffice, size: 28),
                      label: doctor.healthCenter!.name,
                    ),
                  const SizedBox(height: 10),
                  _buildInfoCard(
                    icon: const Icon(Icons.local_hospital, size: 28),
                    label: doctor.healthCenter?.specialties.join(', ') ?? 'No specialties listed',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required Widget icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
