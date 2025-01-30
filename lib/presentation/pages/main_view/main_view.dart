import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tell_me_doctor/config/theme/colors.dart';
import 'package:tell_me_doctor/features/home/presentation/pages/home/home.dart';
import 'package:tell_me_doctor/features/schedule/presentation/pages/schedule/schedule_view.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});
  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends ConsumerState<MainView> {

  @override
  void initState() {
    super.initState();
    //ref.read(authState);
   // ref.read(authNotifierProvider);
  }

  int selectedIndex = 0;
  final List<Widget> pages = [
    const HomeView(),
    const ScheduleView(),
    const Scaffold(),
    const Scaffold(),
  ];

  final List<String> listPages = [
    "Accueil",
    "Rendez-vous",
    "Messages",
    "Profil",
  ];

  @override
  Widget build(BuildContext context) {
    //final authState = ref.watch(authNotifierProvider);
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
      body: Center(
        child: pages[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        //elevation: 0,
        elevation: 50,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black26,
        selectedItemColor: AppColors.kPrimaryColor,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;

            debugPrint("page ici $selectedIndex");
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.home5,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.calendar_1,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.message,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            label: "",
          ),
        ],
      ),
     // body: pages[selectedIndex]
    );
  }
}