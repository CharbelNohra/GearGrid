import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geargrid/animated_splash.dart';
import 'package:go_router/go_router.dart';
import '../common/layouts/main_layout.dart';
import '../features/auth/screens/auth/forgot_password_screen.dart';
import '../features/auth/screens/auth/login_screen.dart';
import '../features/auth/screens/auth/otp_screen.dart';
import '../features/auth/screens/auth/register_screen.dart';
import '../features/auth/screens/cart/cart_screen.dart';
import '../features/auth/screens/profile/update_profile_screen.dart';
import '../features/auth/screens/notifications/notifications_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AnimatedSplashScreen(),
      ),

      GoRoute(
        path: '/main-layout',
        name: 'main-layout',
        builder: (context, state) => MainLayout(),
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

      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => ForgotPasswordScreen(),
      ),

      GoRoute(
        path: '/update-profile',
        name: 'update-profile',
        builder: (context, state) => UpdateProfileScreen(),
      ),

      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => NotificationsScreen(),
      ),

      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => CartScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text(state.error.toString())),
    ),
  );
});