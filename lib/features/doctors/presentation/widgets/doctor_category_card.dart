import 'package:flutter/material.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/doctor_category.dart';

class DoctorCategoryCard extends StatelessWidget {
  final DoctorCategory category;
  final VoidCallback onTap;

  const DoctorCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: category.color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: category.color.withOpacity(.4),
              ),
              height: 50,
              width: 50,
              child: Center(
                child: Text(
                  category.specialty[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: category.color,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Spacer(),
            Text(
              category.specialty,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${category.count} medecins',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}