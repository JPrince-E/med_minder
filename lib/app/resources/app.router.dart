import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_minder/app/services/navigation_service.dart';
import 'package:med_minder/ui/features/create_account/login_views/signin_user_view.dart';
import 'package:med_minder/ui/features/app_nav_bar/app_nav_bar.dart';
import 'package:med_minder/ui/features/emergency/emergency_view/emergency_screen.dart';
import 'package:med_minder/ui/features/homepage/homepage_views/homepage.dart';
import 'package:med_minder/ui/features/profile_view/profile_view.dart';
import 'package:med_minder/ui/features/splash_screen/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      /// App Pages
      GoRoute(
        path: '/homepageView',
        pageBuilder: (context, state) => CustomNormalTransition(
            child: HomepageView(), key: state.pageKey),
      ),
      GoRoute(
        path: '/homeScreen',
        pageBuilder: (context, state) => CustomNormalTransition(
            child: const AppNavBar(), key: state.pageKey),
      ),
      GoRoute(
        path: '/scheduleView',
        pageBuilder: (context, state) =>
            CustomSlideTransition(child: const Scaffold(), key: state.pageKey),
      ),
      GoRoute(
        path: '/profilePageView',
        pageBuilder: (context, state) => CustomNormalTransition(
            child: const ProfilePageView(), key: state.pageKey),
      ),
      GoRoute(
        path: '/signInView',
        builder: (context, state) => SignInView(),
      ),
      GoRoute(
        path: '/emergencyScreen',
        builder: (context, state) => EmergencyScreen(),
      ),
    ],
  );
}

class CustomNormalTransition extends CustomTransitionPage {
  CustomNormalTransition({required LocalKey key, required Widget child})
      : super(
          key: key,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 0),
          child: child,
        );
}

class CustomSlideTransition extends CustomTransitionPage {
  CustomSlideTransition({required LocalKey key, required Widget child})
      : super(
          key: key,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 200),
          child: child,
        );
}
