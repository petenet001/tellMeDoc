import 'package:flutter/material.dart';

class DoctorCategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int doctorsCount;
  final Color color;

  const DoctorCategoryCard(
      {super.key,
      required this.icon,
      required this.label,
      required this.doctorsCount,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: color.withOpacity(0.3) ?? Colors.grey[200],
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
              color: color.withOpacity(.4),
            ),
              height: 50,
              width: 50,
              child: Icon(icon, size: 32, color: color)),
          const SizedBox(height: 8),
          const Spacer(),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '$doctorsCount medecins',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
