// lib/features/auth/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/app_logo.dart';
import 'widgets/login_form.dart';
import '../../../core/utils/snackbar_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _onLoginSuccess() {
    SnackBarHelper.showSuccess(
      context,
      "Login successful!",
      "Welcome back to the app",
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        context.go('/main-layout');
      }
    });
  }

  void _onLoginError(String message) {
    SnackBarHelper.showError(context, "Login Failed", message);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogo(),
                const SizedBox(height: 40),
                LoginForm(
                  onLoginSuccess: _onLoginSuccess,
                  onLoginError: _onLoginError,
                  onForgotPassword: () => context.go('/forgot-password'),
                  onNavigateToRegister: () => context.go('/register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
