import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tell_me_doctor/config/theme/colors.dart';
import 'package:tell_me_doctor/features/account/presentation/pages/profile/profile_view.dart';
import 'package:tell_me_doctor/features/home/presentation/pages/home/home_view.dart';
import 'package:tell_me_doctor/features/messages/presentation/pages/messages/messages_view.dart';
import 'package:tell_me_doctor/features/schedule/presentation/pages/schedule/schedule_view.dart';
import 'package:tell_me_doctor/presentation/riverpod/bottom_nav_provider.dart';



class MainView extends ConsumerWidget {

  MainView({super.key});

  final int selectedIndex = 0;
  final List<Widget> pages = [
    const HomeView(),
    const ScheduleView(),
    const MessagesView(),
    const ProfileView()
  ];

  final List<String> listPages = [
    "Accueil",
    "Rendez-vous",
    "Messages",
    "Profile",
  ];


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        bottomOpacity: 0,
        title: Text(listPages[selectedIndex],style: const TextStyle(fontWeight: FontWeight.w800,fontSize: 28),),
        actions: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black12,
              ),
              color: Colors.white,
            ),
            child: const Icon(
              Iconsax.call,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black12,
              ),
              color: Colors.white,
            ),
            child: const Icon(
              Iconsax.notification,
              size: 20,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      backgroundColor: Colors.white,
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        //elevation: 0,
        type: BottomNavigationBarType.fixed,
        elevation: 80,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black26,
        selectedItemColor: AppColors.kPrimaryColor,
        iconSize: 30,
        currentIndex: selectedIndex,
        onTap: (value) {
          ref.read(bottomNavNotifierProvider.notifier).setIndex(value);
          debugPrint("page ici $value");
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.home_2,
            ),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.calendar_1,
            ),
            label: "Rendez-vous",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.message,
            ),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            label: "Profile",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        context.go('/chat');
      },child:  const HeroIcon(HeroIcons.sparkles)),
    );
  }
}
