
import 'package:flutter/material.dart';

class SeeMoreCategoryCard extends StatelessWidget {
  final VoidCallback onTap;

  const SeeMoreCategoryCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 220, // Assurez-vous que cette largeur correspond à celle de DoctorCategoryCard
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Center(
          child: Text(
            'Voir plus',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}