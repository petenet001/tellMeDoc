import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tell_me_doctor/config/theme/colors.dart';
import 'package:tell_me_doctor/features/account/presentation/widgets/profile_photo.dart';
import 'package:tell_me_doctor/features/account/presentation/widgets/profile_stats.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
         mainAxisSize: MainAxisSize.min,
          children: [

            // Photo de profil et informations
            const ProfilePhoto(),
            const SizedBox(height: 20),
            // Statistiques
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                ProfileStats(value: '2h 30m', label:  'Total time', icon:Icons.timer),
                ProfileStats(value: '7200 cal', label:  'Burned', icon: Icons.local_fire_department),
                ProfileStats(value: '2', label:  'Done', icon:Icons.fitness_center),
              ],
            ),
            const SizedBox(height: 30),

            // Menu items
            Container(
              decoration: BoxDecoration(
                //color: Colors.grey[200],
                color:AppColors.secondaryBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                spacing: 6,
                children: [
                  _buildMenuItem('Personal', Iconsax.user),
                  _buildMenuItem('General', Iconsax.setting_3),
                  _buildMenuItem('Notification', Iconsax.notification),
                  _buildMenuItem('Help', Iconsax.info_circle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Iconsax.arrow_right_3),
    );
  }
}


