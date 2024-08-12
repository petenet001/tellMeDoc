
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

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
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeroIcon(HeroIcons.plusCircle),
            SizedBox(height: 10,),
            Text(
              'more',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}