import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geargrid/animated_splash.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screens/login_screen.dart';

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
        builder: (context, state) => const LoginScreen(),
      ),
      // GoRoute(
      //   path: '/register',
      //   name: 'register',
      //   builder: (context, state) => const RegisterScreen(),
      // ),
      // GoRoute(
      //   path: '/products',
      //   name: 'products',
      //   builder: (context, state) => const ProductListScreen(),
      // ),
      // GoRoute(
      //   path: '/cart',
      //   name: 'cart',
      //   builder: (context, state) => const CartScreen(),
      // ),
      // GoRoute(
      //   path: '/admin',
      //   name: 'admin-dashboard',
      //   builder: (context, state) => const AdminDashboard(),
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text(state.error.toString())),
    ),
  );
});