// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/services/api_services.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (!mounted) return;

    final savedUser = await ApiService.getUser();
    if (savedUser != null) {
      final isAuth = await ApiService.isAuthenticated();

      if (!isAuth) {
        final refreshResult = await ApiService.refreshToken();
        if (refreshResult['success'] && refreshResult['data'] != null) {
          context.go('/main-layout');
          return;
        } else {
          await ApiService.removeToken();
          await ApiService.removeRefreshToken();
          await ApiService.removeUser();
          context.go('/login');
          return;
        }
      } else {
        context.go('/main-layout');
        return;
      }
    } else {
      context.go('/login');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Image.asset(
          'assets/gif/logo.gif',
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}