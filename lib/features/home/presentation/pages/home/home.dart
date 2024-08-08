import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tell_me_doctor/features/auth/presentation/riverpod/auth_providers.dart';
import 'package:tell_me_doctor/features/home/presentation/widgets/doctor_categories_section.dart';
import 'package:tell_me_doctor/features/home/presentation/widgets/top_doctors_section.dart';

import '../../../../doctors/presentation/widgets/doctor_category_card.dart';

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
        actions: [
          /*CircleAvatar(
            backgroundImage: AssetImage('assets/doctor_background.png'),
          ),*/
          const SizedBox(width: 16),
          IconButton(onPressed: () {}, icon: const HeroIcon(HeroIcons.ellipsisVertical)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Salut, ${authState.user?.name ?? "User"}!',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
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
                        image: const DecorationImage(
                            image: AssetImage('assets/doctor_background.png'),
                            fit: BoxFit.cover)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Comment vous sentez-vous \naujourd'hui ?",
                style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 24),
            const SizedBox(
              height: 300, // Ajustez cette hauteur selon vos besoins
              child: DoctorCategoriesSection(),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TopDoctorsSection(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go("/chat");
        },
        child: const HeroIcon(HeroIcons.sparkles),
      ),
    );
  }
}
