// lib/features/auth/screens/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/forgot_password_form.dart';
import 'widgets/auth_header.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  void _onResetEmailSent(String email) async {
    // Navigate to OTP verification for password reset
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OTPVerificationScreen(
          email: email,
          isPasswordReset: true, // Add this parameter to your OTP screen
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            AuthHeader(
              onBackPressed: () => context.go('/login'),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ForgotPasswordForm(
                    onResetEmailSent: _onResetEmailSent,
                    onError: _showError,
                    onSuccess: _showSuccess,
                    onBackToLogin: () => context.go('/login'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}