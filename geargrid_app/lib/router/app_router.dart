import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geargrid/animated_splash.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/otp_screen.dart';
import '../features/auth/screens/register_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AnimatedSplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) => OTPVerificationScreen(
          email: ModalRoute.of(context)!.settings.arguments is Map
                ? (ModalRoute.of(context)!.settings.arguments as Map)['email']
                : '',
            phoneNumber: ModalRoute.of(context)!.settings.arguments is Map
                ? (ModalRoute.of(context)!.settings.arguments as Map)['phoneNumber']
                : '',
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text(state.error.toString())),
    ),
  );
});