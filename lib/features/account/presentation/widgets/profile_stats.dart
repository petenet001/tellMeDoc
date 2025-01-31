import 'package:flutter/material.dart';
import 'package:tell_me_doctor/config/theme/colors.dart';

class ProfileStats extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const ProfileStats({super.key, required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       Container(
         padding: const EdgeInsets.all(10),
         alignment: Alignment.center,
         width: 60,
         height: 60,
         decoration: BoxDecoration(
           //color: Colors.grey[200],
           //color: AppColors.kPrimaryColorOpacity,
           color: AppColors.secondaryBgColor,
           borderRadius: BorderRadius.circular(10),
         ),
         child:  Icon(icon, color: Colors.grey),
       ),
        const SizedBox(height: 10,),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
