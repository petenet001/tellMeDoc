import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tell_me_doctor/presentation/widgets/content_section.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  Future<void> _checkFirstSeen(BuildContext context) async {
   /* SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);*/

    /*if (seen) {
      context.go('/auth_state');
    } else {
      await prefs.setBool('seen', true);
    }*/

    context.go('/main-page');
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstSeen(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/doctor_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Purple gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ Colors.purple.withOpacity(0.9), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
          ),
          const ContentSection(),
        ],
      ),
    );
  }
}