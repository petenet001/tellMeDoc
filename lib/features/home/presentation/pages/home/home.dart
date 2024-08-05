import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tell_me_doctor/features/auth/presentation/riverpod/auth_providers.dart';
import 'package:tell_me_doctor/features/home/presentation/widgets/doctor_list_tile.dart';

import '../../widgets/doctor_category_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: const Text(
          'Tell Me Doc',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        actions: const [
          /*CircleAvatar(
            backgroundImage: AssetImage('assets/doctor_background.png'),
          ),*/
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Salut, ${authState.user?.name ?? "User"}!',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    height: 60,
                    width: 60,
                    margin: const EdgeInsets.only(top: 24.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.red,
                    image: const DecorationImage(image: AssetImage('assets/doctor_background.png'),fit: BoxFit.cover)
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Comment vous sentez-vous \n aujourd'hui ?",
                style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300, // Ajustez cette hauteur selon vos besoins
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  InkWell(
                    child: const DoctorCategoryCard(
                      icon: Icons.favorite,
                      label: 'Cardio',
                      doctorsCount: 12,
                      color: Colors.red,
                    ),
                    onTap: () {
                      context.go('/profile');
                    },
                  ),
                  const SizedBox(width: 16), // Espace entre les cartes
                  const DoctorCategoryCard(
                    icon: Icons.face,
                    label: 'Dental',
                    doctorsCount: 9,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  const DoctorCategoryCard(
                    icon: Icons.visibility,
                    label: 'Eye',
                    doctorsCount: 5,
                    color: Colors.green,
                  ),
                  // Vous pouvez ajouter plus de catégories ici
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Top doctors',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  DoctorListTile(
                    name: 'Dr. Jenny Wilson',
                    specialty: 'Cardiologist',
                    hospital: 'Bristol Hospital',
                    time: '4:30 PM - 5:00 PM',
                  ),
                  DoctorListTile(
                    name: 'Dr. Robert Fox',
                    specialty: 'Dentist',
                    hospital: 'Bristol Hospital',
                    time: '4:30 PM - 5:00 PM',
                  ),
                  DoctorListTile(
                    name: 'Dr. Jacob Jones',
                    specialty: 'Eye Specialist',
                    hospital: 'Bristol Hospital',
                    time: '4:30 PM - 5:00 PM',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go("/chat");
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
