import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tell_me_doctor/features/auth/presentation/riverpod/auth_providers.dart';
import 'package:tell_me_doctor/features/auth/presentation/pages/login/login.dart';
import 'package:tell_me_doctor/features/auth/presentation/riverpod/auth_state.dart';
import 'package:tell_me_doctor/features/home/presentation/pages/home/home.dart';

class AuthPage extends ConsumerWidget {
  final Widget? child;

  const AuthPage({super.key, this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authNotifierProvider, (_, state) {
      if (state.user == null && !state.isLoading) {
        context.go('/login');
      }
    });

    final authState = ref.watch(authNotifierProvider);

    if (authState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (authState.user != null) {
      return child ?? const HomePage();
    } else if (authState.errorMessage != null) {
      return Scaffold(
        body: Center(child: Text('Error: ${authState.errorMessage}')),
      );
    } else {
      return const LoginPage();
    }
  }
}