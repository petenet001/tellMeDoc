import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tell_me_doctor/presentation/pages/main_view/main_view.dart';

class AuthPage extends ConsumerWidget {
  final Widget? child;

  const AuthPage({super.key, this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return const MainView();

/*    if (authState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (authState.user != null) {
      return child ?? const MainView();
    } else if (authState.errorMessage != null) {
      return Scaffold(
        body: Center(child: Text('Error: ${authState.errorMessage}')),
      );
    } else {
      return const LoginPage();
    }*/
  }
}
