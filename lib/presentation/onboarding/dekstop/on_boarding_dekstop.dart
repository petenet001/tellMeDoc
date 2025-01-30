import 'package:flutter/material.dart';
import 'package:tell_me_doctor/config/responsivity/screen_utils.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

/*
  Future<void> _checkFirstSeen(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);

    if (seen) {
      context.go('/auth_state');
    } else {
      await prefs.setBool('seen', true);
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
                color: Colors.green,
                width: ScreenUtils.screenWidth(context),
                height: ScreenUtils.screenHeight(context),
                child: const Text("tablet left")),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.deepOrange,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text("tablet Right")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}