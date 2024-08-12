import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tell_me_doctor/features/auth/presentation/riverpod/auth_providers.dart';
import 'package:tell_me_doctor/features/home/presentation/widgets/doctor_categories_section.dart';
import 'package:tell_me_doctor/features/home/presentation/widgets/top_doctors_section.dart';

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
          PopupMenuButton<int>(
            icon: const HeroIcon(HeroIcons.ellipsisVertical),
            onSelected: (int value) async {
              switch (value) {
                case 0:
                  context.push('/profile');
                  break;
                case 1:
                  context.push('/about');
                  break;
                case 2:
                  final shouldSignOut =
                      await _showSignOutConfirmationDialog(context);
                  if (shouldSignOut == true) {
                    ref.read(authNotifierProvider.notifier).signOut(context);
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<int>(value: 0, child: Text('Profile')),
              const PopupMenuItem<int>(value: 1, child: Text('À propos')),
              const PopupMenuItem<int>(value: 2, child: Text('Déconnexion')),
            ],
          ),
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
                        _getGreetingMessage(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        authState.user?.firstName != null
                            ? '${authState.user?.firstName ?? ""}!'
                            : 'Bienvenue !',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ), //petenet001@gmail.com
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 20),
                  child: GestureDetector(
                    onTap: () {
                      context.push('/profile');
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: authState.user?.photoUrl != null
                          ? _getImageProvider(authState.user!.photoUrl!)
                          : const AssetImage("assets/avatar_placeholder.png")
                              as ImageProvider,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Comment vous sentez-vous \naujourd'hui ?",
                style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 24),
            const SizedBox(
              height: 300,
              child: DoctorCategoriesSection(),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Top doctors',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        context.push("/all-doctors");
                      },
                      child: const Text(
                        "more",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ))
                ],
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
          context.push("/chat");
        },
        child: const HeroIcon(HeroIcons.sparkles),
      ),
    );
  }

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Bonjour';
    } else if (hour < 18) {
      return 'Bon après-midi';
    } else {
      return 'Bonsoir';
    }
  }

  ImageProvider _getImageProvider(String urlOrPath) {
    if (urlOrPath.startsWith('http') || urlOrPath.startsWith('https')) {
      return NetworkImage(urlOrPath);
    } else {
      return FileImage(File(urlOrPath));
    }
  }

  Future<bool?> _showSignOutConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer la déconnexion"),
        content: const Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Déconnexion"),
          ),
        ],
      ),
    );
  }
}
