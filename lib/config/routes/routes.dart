import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tell_me_doctor/features/docai/presentation/pages/doctor_ai/doc_ai.dart';
import 'package:tell_me_doctor/presentation/onboarding/mobile/on_boarding.dart';
import 'package:tell_me_doctor/presentation/main_view/main_view.dart';

import '../../features/auth/presentation/pages/auth/auth.dart';
import '../../features/auth/presentation/pages/profile/profile.dart';
import '../../features/auth/presentation/pages/register/register.dart'; // Ajoutez cette ligne

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const OnBoardingPage();
      },
    ),
    GoRoute(
      path: '/auth_state',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const AuthPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/main-page',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child:  MainView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const ProfilePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    /*GoRoute(
      path: '/about',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const AboutPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    ),*/
    /*  GoRoute(
      path: '/auth',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    ),*/
    GoRoute(
      path: '/register', // Nouvelle route pour la page d'enregistrement
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterPage(), // Assurez-vous d'avoir créé cette page
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/chat',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const DocAiPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    /* GoRoute(
      path: '/doc_profile/:id',
      pageBuilder: (BuildContext context, GoRouterState state) {
        final doctor = state.extra as MedicalProvider;
        return CustomTransitionPage(
          key: state.pageKey,
          child: DoctorProfilePage(doctor: doctor),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    ),*/
    /* GoRoute(
      path: '/doctors/:category',
      pageBuilder: (BuildContext context, GoRouterState state) {
        final category = state.pathParameters['category']!;
        return CustomTransitionPage(
          key: state.pageKey,
          child: DoctorCategoryDetailsPage(category: category),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    ),*/
    /*  GoRoute(
      path: '/all-categories',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const AllDoctorCategoriesPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.bounceInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),*/
    /* GoRoute(
      path: '/all-doctors',
      pageBuilder: (BuildContext context, GoRouterState state) {
        final city = state.pathParameters['city'] ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: AllDoctorsPage(city: city),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.bounceInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),*/
  ],
  initialLocation: '/',
);
